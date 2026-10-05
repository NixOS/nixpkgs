{
  baseConfig =
    { config, pkgs, ... }:
    let
      trivialJob = pkgs.writeTextDir "trivial.nix" ''
        { trivial = derivation {
            name = "trivial";
            system = "${pkgs.stdenv.hostPlatform.system}";
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
        nativeBuildInputs = [ pkgs.makeWrapper ];
        installPhase = "install -m755 -D ${./create-trivial-project.sh} $out/bin/create-trivial-project.sh";
        postFixup = ''
          wrapProgram "$out/bin/create-trivial-project.sh" --prefix PATH ":" ${
            pkgs.lib.makeBinPath [ pkgs.curl ]
          } --set EXPR_PATH ${trivialJob}
        '';
      };
    in
    {
      virtualisation.memorySize = 2048;
      time.timeZone = "UTC";
      environment.systemPackages = [
        createTrivialProject
        pkgs.jq
      ];
      services.hydra = {
        enable = true;
        # Hydra needs those settings to start up, so we add something not harmfull.
        hydraURL = "example.com";
        notificationSender = "example@example.com";
        extraConfig = ''
          <email_notifications>
            build = 1
          </email_notifications>
        '';
      };

      # Local build agent so that queued builds actually get executed.
      services.hydra-builder = {
        enable = true;
        queueRunnerAddr = "http://[::1]:${toString config.services.hydra.queueRunner.grpc.port}";
      };
      systemd.services.hydra-builder.after = [ "hydra-queue-runner.service" ];

      services.postfix.enable = true;
      nix.settings.substituters = [ ];
      nix.enable = true; # disabled by default. See all-tests.nix / tag(no-nix-by-default)
    };
}
