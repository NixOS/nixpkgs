{ system, ... }:
{
  baseConfig = { pkgs, ... }: let
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
        wrapProgram "$out/bin/create-trivial-project.sh" --prefix PATH ":" ${pkgs.lib.makeBinPath [ pkgs.curl ]} --set EXPR_PATH ${trivialJob}
      '';
    };
  in {
    virtualisation.memorySize = 2048;
    time.timeZone = "UTC";
    environment.systemPackages = [ createTrivialProject pkgs.jq ];
    services.hydra = {
      enable = true;
      # Hydra needs those settings to start up, so we add something not harmfull.
      hydraURL = "example.com";
      notificationSender = "example@example.com";
      extraConfig = ''
        email_notification = 1
      '';
    };
    services.postfix.enable = true;
    nix = {
      distributedBuilds = true;
      buildMachines = [{
        hostName = "localhost";
        systems = [ system ];
      }];
      settings.substituters = [];
    };
  };
}
