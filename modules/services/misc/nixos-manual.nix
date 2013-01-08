# This module includes the NixOS man-pages in the system environment,
# and optionally starts a browser that shows the NixOS manual on one
# of the virtual consoles.  The latter is useful for the installation
# CD.

{ config, pkgs, options, ... }:

with pkgs.lib;

let

  cfg = config.services.nixosManual;

  manual = import ../../../doc/manual {
    inherit (cfg) revision;
    inherit pkgs options;
  };

  entry = "${manual.manual}/share/doc/nixos/manual.html";

  help = pkgs.writeScriptBin "nixos-help"
    ''
      #! ${pkgs.stdenv.shell} -e
      if ! ''${BROWSER:-w3m} ${entry}; then
        echo "$0: unable to start a web browser; please set \$BROWSER or install ‘w3m’"
        exit 1
      fi
    '';

in

{

  options = {

    services.nixosManual.enable = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to build the NixOS manual pages.
      '';
    };

    services.nixosManual.showManual = mkOption {
      default = false;
      description = ''
        Whether to show the NixOS manual on one of the virtual
        consoles.
      '';
    };

    services.nixosManual.ttyNumber = mkOption {
      default = "8";
      description = ''
        Virtual console on which to show the manual.
      '';
    };

    services.nixosManual.browser = mkOption {
      default = "${pkgs.w3m}/bin/w3m";
      description = ''
        Browser used to show the manual.
      '';
    };

    services.nixosManual.revision = mkOption {
      default = "local";
      type = types.uniq types.string;
      description = ''
        Revision of the targeted source file.  This value can either be
        <literal>"local"</literal>, <literal>"HEAD"</literal> or any
        revision number embedded in a string.
      '';
    };

  };


  config = mkIf cfg.enable {

    system.build.manual = manual;

    environment.systemPackages = [ manual.manpages help ];

    boot.extraTTYs = mkIf cfg.showManual ["tty${cfg.ttyNumber}"];

    boot.systemd.services = optionalAttrs cfg.showManual
      { "nixos-manual" =
        { description = "NixOS Manual";
          wantedBy = [ "multi-user.target" ];
          serviceConfig =
            { ExecStart = "${cfg.browser} ${entry}";
              StandardInput = "tty";
              StandardOutput = "tty";
              TTYPath = "/dev/tty${cfg.ttyNumber}";
              TTYReset = true;
              TTYVTDisallocate = true;
              Restart = "always";
            };
        };
      };

    services.ttyBackgrounds.specificThemes = mkIf cfg.showManual
      [ { tty = "tty${cfg.ttyNumber}";
          theme = pkgs.themes "green";
        }
      ];

    services.mingetty.helpLine = mkIf cfg.showManual
      "\nPress <Alt-F${toString cfg.ttyNumber}> for the NixOS manual.";

  };

}
