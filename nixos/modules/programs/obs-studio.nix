{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.programs.obs-studio;
in
{
  options.programs.obs-studio = {
    enable = lib.mkEnableOption "Free and open source software for video recording and live streaming";

    package = lib.mkPackageOption pkgs "obs-studio" { example = "obs-studio"; };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      visible = false;
      readOnly = true;
      description = "Resulting customized OBS Studio package.";
    };

    plugins = lib.mkOption {
      default = [ ];
      example = lib.literalExpression "[ pkgs.obs-studio-plugins.wlrobs ]";
      description = "Optional OBS plugins.";
      type = lib.types.listOf lib.types.package;
    };

    enableVirtualCamera = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Installs and sets up the v4l2loopback kernel module, necessary for OBS
        to start a virtual camera.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio.finalPackage = pkgs.wrapOBS.override { obs-studio = cfg.package; } {
      plugins = cfg.plugins;
    };

    environment.systemPackages = [ cfg.finalPackage ];

    boot = lib.mkIf cfg.enableVirtualCamera {
      kernelModules = [ "v4l2loopback" ];
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
    };

    security.polkit.enable = lib.mkIf cfg.enableVirtualCamera true;
  };

  meta.maintainers = with lib.maintainers; [
    CaptainJawZ
    GaetanLepage
  ];
}
