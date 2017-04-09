# This module includes the NixOS man-pages in the system environment,
# and optionally starts a browser that shows the NixOS manual on one
# of the virtual consoles.  The latter is useful for the installation
# CD.

{ config, lib, pkgs, baseModules, ... }:

with lib;

let

  cfg = config.services.nixosManual;

  /* For the purpose of generating docs, evaluate options with each derivation
    in `pkgs` (recursively) replaced by a fake with path "\${pkgs.attribute.path}".
    It isn't perfect, but it seems to cover a vast majority of use cases.
    Caveat: even if the package is reached by a different means,
    the path above will be shown and not e.g. `${config.services.foo.package}`. */
  manual = import ../../../doc/manual {
    inherit pkgs config;
    version = config.system.nixosRelease;
    revision = "release-${config.system.nixosRelease}";
    options =
      let
        scrubbedEval = evalModules {
          modules = [ { nixpkgs.system = config.nixpkgs.system; } ] ++ baseModules;
          args = (config._module.args) // { modules = [ ]; };
          specialArgs = { pkgs = scrubDerivations "pkgs" pkgs; };
        };
        scrubDerivations = namePrefix: pkgSet: mapAttrs
          (name: value:
            let wholeName = "${namePrefix}.${name}"; in
            if isAttrs value then
              scrubDerivations wholeName value
              // (optionalAttrs (isDerivation value) { outPath = "\${${wholeName}}"; })
            else value
          )
          pkgSet;
      in scrubbedEval.options;
  };

  entry = "${manual.manual}/share/doc/nixos/index.html";

  helpScript = pkgs.writeScriptBin "nixos-help"
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

  desktopItem = pkgs.makeDesktopItem {
    name = "nixos-manual";
    desktopName = "NixOS Manual";
    genericName = "View NixOS documentation in a web browser";
    # TODO: find a better icon (Nix logo + help overlay?)
    icon = "system-help";
    exec = "${helpScript}/bin/nixos-help";
    categories = "System";
  };
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
      type = types.int;
      default = 8;
      description = ''
        Virtual console on which to show the manual.
      '';
    };

    services.nixosManual.browser = mkOption {
      type = types.path;
      default = "${pkgs.w3m-nox}/bin/w3m";
      description = ''
        Browser used to show the manual.
      '';
    };

  };


  config = mkIf cfg.enable {

    system.build.manual = manual;

    environment.systemPackages =
      [ manual.manual helpScript ]
      ++ optional config.services.xserver.enable desktopItem
      ++ optional config.programs.man.enable manual.manpages;

    boot.extraTTYs = mkIf cfg.showManual ["tty${toString cfg.ttyNumber}"];

    systemd.services = optionalAttrs cfg.showManual
      { "nixos-manual" =
        { description = "NixOS Manual";
          wantedBy = [ "multi-user.target" ];
          serviceConfig =
            { ExecStart = "${cfg.browser} ${entry}";
              StandardInput = "tty";
              StandardOutput = "tty";
              TTYPath = "/dev/tty${toString cfg.ttyNumber}";
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
