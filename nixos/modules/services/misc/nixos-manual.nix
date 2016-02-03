# This module includes the NixOS man-pages in the system environment,
# and optionally starts a browser that shows the NixOS manual on one
# of the virtual consoles.  The latter is useful for the installation
# CD.

{ config, lib, pkgs, baseModules, ... }:

with lib;

let

  cfg = config.services.nixosManual;

  versionModule =
    { system.nixosVersionSuffix = config.system.nixosVersionSuffix;
      system.nixosRevision = config.system.nixosRevision;
      nixpkgs.system = config.nixpkgs.system;
    };

  eval = evalModules {
    modules = [ versionModule ] ++ baseModules;
    args = (config._module.args) // { modules = [ ]; };
  };

  manual = import ../../../doc/manual {
    inherit pkgs;
    version = config.system.nixosVersion;
    revision = config.system.nixosRevision;
    options = eval.options;
  };

  entry = "${manual.manual}/share/doc/nixos/index.html";

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
      type = types.bool;
      default = true;
      description = ''
        Whether to build the NixOS manual pages.
      '';
    };

    services.nixosManual.showManual = mkOption {
      type = types.bool;
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
      type = types.path;
      description = ''
        Browser used to show the manual.
      '';
    };

  };


  config = mkIf cfg.enable {

    system.build.manual = manual;

    environment.systemPackages =
      [ manual.manual help ]
      ++ optional config.programs.man.enable manual.manpages;

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

    services.nixosManual.browser = mkDefault "${pkgs.w3m-nox}/bin/w3m";

  };

}
