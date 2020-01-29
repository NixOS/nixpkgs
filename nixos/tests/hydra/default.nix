{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:

let

  trivialJob = pkgs.writeTextDir "trivial.nix" ''
   { trivial = builtins.derivation {
       name = "trivial";
       system = "${system}";
       builder = "/bin/sh";
       allowSubstitutes = false;
       preferLocalBuild = true;
       args = ["-c" "echo success > $out; exit 0"];
     };
   }
  '';

  createTrivialProject = pkgs.stdenv.mkDerivation {
    name = "create-trivial-project";
    dontUnpack = true;
    buildInputs = [ pkgs.makeWrapper ];
    installPhase = "install -m755 -D ${./create-trivial-project.sh} $out/bin/create-trivial-project.sh";
    postFixup = ''
      wrapProgram "$out/bin/create-trivial-project.sh" --prefix PATH ":" ${pkgs.stdenv.lib.makeBinPath [ pkgs.curl ]} --set EXPR_PATH ${trivialJob}
    '';
  };

  callTest = f: f { inherit system pkgs; };

  hydraPkgs = {
    inherit (pkgs) nixStable nixUnstable nixFlakes;
  };

  tests = pkgs.lib.flip pkgs.lib.mapAttrs hydraPkgs (name: nix:
    callTest (import ../make-test-python.nix ({ pkgs, lib, ... }:
      {
        name = "hydra-with-${name}";
        meta = with pkgs.stdenv.lib.maintainers; {
          maintainers = [ pstn lewo ma27 ];
        };

        machine = { pkgs, ... }:
          {
            virtualisation.memorySize = 1024;
            time.timeZone = "UTC";

            environment.systemPackages = [ createTrivialProject pkgs.jq ];
            services.hydra = {
              enable = true;

              #Hydra needs those settings to start up, so we add something not harmfull.
              hydraURL = "example.com";
              notificationSender = "example@example.com";

              package = pkgs.hydra.override { inherit nix; };

              extraConfig = ''
                email_notification = 1
              '';
            };
            services.postfix.enable = true;
            nix = {
              buildMachines = [{
                hostName = "localhost";
                systems = [ system ];
              }];

              binaryCaches = [];
            };
          };

        testScript = ''
          # let the system boot up
          machine.wait_for_unit("multi-user.target")
          # test whether the database is running
          machine.wait_for_unit("postgresql.service")
          # test whether the actual hydra daemons are running
          machine.wait_for_unit("hydra-init.service")
          machine.require_unit_state("hydra-queue-runner.service")
          machine.require_unit_state("hydra-evaluator.service")
          machine.require_unit_state("hydra-notify.service")

          machine.succeed("hydra-create-user admin --role admin --password admin")

          # create a project with a trivial job
          machine.wait_for_open_port(3000)

          # make sure the build as been successfully built
          machine.succeed("create-trivial-project.sh")

          machine.wait_until_succeeds(
              'curl -L -s http://localhost:3000/build/1 -H "Accept: application/json" |  jq .buildstatus | xargs test 0 -eq'
          )

          machine.wait_until_succeeds(
              'journalctl -eu hydra-notify.service -o cat | grep -q "sending mail notification to hydra@localhost"'
          )
        '';
      })));

in
  tests
