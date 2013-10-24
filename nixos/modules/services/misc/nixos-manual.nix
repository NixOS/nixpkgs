# This module includes the NixOS man-pages in the system environment,
# and optionally starts a browser that shows the NixOS manual on one
# of the virtual consoles.  The latter is useful for the installation
# CD.

{ config, pkgs, baseModules, ... } @ extraArgs:

with pkgs.lib;

let

  cfg = config.services.nixosManual;

  manual = import ../../../doc/manual {
    inherit pkgs;
    revision =
      let fn = "${toString pkgs.path}/.git-revision";
      in if pathExists fn then readFile fn else "master";
    options = (fixMergeModules baseModules
      (removeAttrs extraArgs ["config" "options"]) // {
        modules = [ ];
      }).options;
  };

  entry = "${manual.manual}/share/doc/nixos/manual.html";

  help = pkgs.writeScriptBin "nixos-help"
    ''
      #! ${pkgs.stdenv.shell} -e
      browser="$BROWSER"
      if [ -z "$browser" ]; then
        browser="$(type -P xdg-open || true)"
        if [ -z "$browser" ]; then
          browser="$(type -P w3m || true)"
          if [ -z "$browser" ]; then
            echo "$0: unable to start a web browser; please set \$BROWSER"
            exit 1
          fi
        fi
      fi
      exec "$browser" ${entry}
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

  };


  config = mkIf cfg.enable {

    system.build.manual = manual;

    environment.systemPackages = [ manual.manpages help ];

    boot.extraTTYs = mkIf cfg.showManual ["tty${cfg.ttyNumber}"];

    systemd.services = optionalAttrs cfg.showManual
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

    services.mingetty.helpLine = mkIf cfg.showManual
      "\nPress <Alt-F${toString cfg.ttyNumber}> for the NixOS manual.";

  };

}
