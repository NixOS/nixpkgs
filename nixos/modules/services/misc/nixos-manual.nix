# This module optionally starts a browser that shows the NixOS manual
# on one of the virtual consoles which is useful for the installation
# CD.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nixosManual;
  cfgd = config.documentation;
in

{

  options = {

    # TODO(@oxij): rename this to `.enable` eventually.
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
      default = "${pkgs.w3m-nographics}/bin/w3m";
      description = ''
        Browser used to show the manual.
      '';
    };

  };


  config = mkMerge [
    (mkIf cfg.showManual {
      assertions = singleton {
        assertion = cfgd.enable && cfgd.nixos.enable;
        message   = "Can't enable `services.nixosManual.showManual` without `documentation.nixos.enable`";
      };
    })
    (mkIf (cfg.showManual && cfgd.enable && cfgd.nixos.enable) {
      console.extraTTYs = [ "tty${toString cfg.ttyNumber}" ];

      systemd.services.nixos-manual = {
        description = "NixOS Manual";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${cfg.browser} ${config.system.build.manual.manualHTMLIndex}";
          StandardInput = "tty";
          StandardOutput = "tty";
          TTYPath = "/dev/tty${toString cfg.ttyNumber}";
          TTYReset = true;
          TTYVTDisallocate = true;
          Restart = "always";
        };
      };
    })
  ];

}
