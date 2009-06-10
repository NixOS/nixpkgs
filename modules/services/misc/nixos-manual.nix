{pkgs, config, ...}:

# Show the NixOS manual on tty8
# Originally used only by installation CD

let
  inherit (pkgs.lib) mkOption;

  options = {
    services = {

      showManual = {

        enable = mkOption {
          default = false;
          description = "
            Whether to show the NixOS manual on one of the virtual
            consoles.
          ";
        };

        ttyNumber = mkOption {
          default = "8";
          description = "
            Virtual console on which to show the manual.
          ";
        };

        browser = mkOption {
          default = "${pkgs.w3m}/bin/w3m";
          description = ''
            Browser used to show the manual.
          '';
        };

        manualFile = mkOption {
          # Note: we can't use a default here (see below), since it
          # causes an infinite recursion building the manual.
          default = null; 
          description = "
            NixOS manual HTML file
          ";
        };

      }; # showManual

    }; # services
  };
in

let
  inherit (config.services.showManual) enable ttyNumber browser manualFile;

  realManualFile =
    if manualFile == null then
      # We could speed up the evaluation of the manual expression by
      # providing it the optionDeclarations of the current
      # configuration.
      "${import ../../../doc/manual {inherit pkgs;}}/manual.html"
    else
      manualFile;

  inherit (pkgs.lib) mkIf mkThenElse;
in

mkIf enable {
  require = [
    options
  ];

  boot = {
    extraTTYs = [ ttyNumber ];
  };

  services = {

    extraJobs = [{
      name = "nixos-manual";

      job = ''
        description "NixOS manual"

        start on udev
        stop on shutdown
        respawn ${browser} ${realManualFile} < /dev/tty${toString ttyNumber} > /dev/tty${toString ttyNumber} 2>&1
      '';
    }];

    ttyBackgrounds = {
      specificThemes = [{
        tty = ttyNumber;
        theme = pkgs.themes "green";
      }];
    };

    mingetty = {
      helpLine = mkThenElse {
        thenPart = "\nPress <Alt-F${toString ttyNumber}> for the NixOS manual.";
        elsePart = "";
      };
    };

  };
}
