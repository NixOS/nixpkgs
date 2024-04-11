{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.programs.coolercontrol;
in
{
  ##### interface
  options = {
    programs.coolercontrol.enable = lib.mkEnableOption (lib.mdDoc "CoolerControl GUI & its background services");
  };

  ##### implementation
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs.coolercontrol; [
      coolercontrol-gui
    ];

    systemd = {
      packages = with pkgs.coolercontrol; [
        coolercontrol-liqctld
        coolercontrold
      ];

      # https://github.com/NixOS/nixpkgs/issues/81138
      services = {
        coolercontrol-liqctld.wantedBy = [ "multi-user.target" ];
        coolercontrold.wantedBy = [ "multi-user.target" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ OPNA2608 codifryed ];
}
