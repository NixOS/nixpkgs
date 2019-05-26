{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:

let

  trivialJob = pkgs.writeTextDir "trivial.nix" ''
   { trivial = builtins.derivation {
       name = "trivial";
       system = "x86_64-linux";
       builder = "/bin/sh";
       args = ["-c" "echo success > $out; exit 0"];
     };
   }
  '';

  createTrivialProject = pkgs.stdenv.mkDerivation {
    name = "create-trivial-project";
    unpackPhase = ":";
    buildInputs = [ pkgs.makeWrapper ];
    installPhase = "install -m755 -D ${./create-trivial-project.sh} $out/bin/create-trivial-project.sh";
    postFixup = ''
      wrapProgram "$out/bin/create-trivial-project.sh" --prefix PATH ":" ${pkgs.stdenv.lib.makeBinPath [ pkgs.curl ]} --set EXPR_PATH ${trivialJob}
    '';
  };

  callTest = f: f { inherit system pkgs; };

  hydraPkgs = {
    inherit (pkgs) nixStable nixUnstable;
  };

  tests = pkgs.lib.flip pkgs.lib.mapAttrs hydraPkgs (name: nix:
    callTest (import ../make-test.nix ({ pkgs, lib, ... }:
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
            };
            nix = {
              buildMachines = [{
                hostName = "localhost";
                systems = [ "x86_64-linux" ];
              }];

              binaryCaches = [];
            };
          };

        testScript = ''
          # let the system boot up
          $machine->waitForUnit("multi-user.target");
          # test whether the database is running
          $machine->succeed("systemctl status postgresql.service");
          # test whether the actual hydra daemons are running
          $machine->succeed("systemctl status hydra-queue-runner.service");
          $machine->succeed("systemctl status hydra-init.service");
          $machine->succeed("systemctl status hydra-evaluator.service");
          $machine->succeed("systemctl status hydra-send-stats.service");

          $machine->succeed("hydra-create-user admin --role admin --password admin");

          # create a project with a trivial job
          $machine->waitForOpenPort(3000);

          # make sure the build as been successfully built
          $machine->succeed("create-trivial-project.sh");

          $machine->waitUntilSucceeds('curl -L -s http://localhost:3000/build/1 -H "Accept: application/json" |  jq .buildstatus | xargs test 0 -eq');
        '';
      })));

in
  tests
