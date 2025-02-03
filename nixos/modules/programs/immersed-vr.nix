{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.immersed-vr;
in
{

  options = {
    programs.immersed-vr = {
      enable = lib.mkEnableOption "immersed-vr";

      package = lib.mkPackageOption pkgs "immersed-vr" {};
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelModules = [ "v4l2loopback" "snd-aloop" ];
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 card_label="v4l2loopback Virtual Camera"
      '';
    };

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = pkgs.immersed-vr.meta.maintainers;
}
