{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      mingetty = {

        ttys = mkOption {
          default = [1 2 3 4 5 6];
          description = "
            The list of tty (virtual console) devices on which to start a
            login prompt.
          ";
        };

        waitOnMounts = mkOption {
          default = false;
          description = "
            Whether the login prompts on the virtual consoles will be
            started before or after all file systems have been mounted.  By
            default we don't wait, but if for example your /home is on a
            separate partition, you may want to turn this on.
          ";
        };

        greetingLine = mkOption {
          default = ''<<< Welcome to NixOS (\m) - Kernel \r (\l) >>>'';
          description = "
            Welcome line printed by mingetty.
          ";
        };

        helpLine = mkOption {
          default = "";
          description = "
            Help line printed by mingetty below the welcome line.
            Used by the installation CD to give some hints on
            how to proceed.
          ";
        };

      };
    };
  };
in

###### implementation

let
  ttyNumbers = config.services.mingetty.ttys;
  loginProgram = "${pkgs.pam_login}/bin/login";
  inherit (pkgs) mingetty;
    
in

{
  require = [
    options
  ];

  services.extraJobs = map (ttyNumber : {
    name = "tty" + toString ttyNumber;
    job = ''
      start on udev
      stop on shutdown
      respawn ${mingetty}/sbin/mingetty --loginprog=${loginProgram} --noclear tty${toString ttyNumber}
    '';
  }) ttyNumbers;

  environment.etc =
    [ { # Friendly greeting on the virtual consoles.
        source = pkgs.writeText "issue" ''
      
          [1;32m${config.services.mingetty.greetingLine}[0m
          ${config.services.mingetty.helpLine}
        
        '';
        target = "issue";
      }
    ];
}
