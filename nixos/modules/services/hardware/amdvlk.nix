{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.amdgpu.amdvlk;
in {
  options.hardware.amdgpu.amdvlk = {
    enable = lib.mkEnableOption "AMDVLK Vulkan driver";

    package = lib.mkPackageOption pkgs "amdvlk" { };

    supportExperimental.enable = lib.mkEnableOption "Experimental features support";

    support32Bit.enable = lib.mkEnableOption "32-bit driver support";
    support32Bit.package = lib.mkPackageOption pkgs.driversi686Linux "amdvlk" { };
  };

  config = lib.mkIf cfg.enable {
    hardware.opengl = lib.mkMerge [
      {
        enable = lib.mkDefault true;
        driSupport = lib.mkDefault true;
        extraPackages = [ cfg.package ];
      }
      (lib.mkIf cfg.support32Bit.enable {
        driSupport32Bit = lib.mkDefault true;
        extraPackages32 = [ cfg.support32Bit.package ];
      })
    ];

    services.xserver.videoDrivers = [ "amdgpu" ];

    environment.sessionVariables = lib.mkIf cfg.supportExperimental.enable {
      AMDVLK_ENABLE_DEVELOPING_EXT = "all";
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ johnrtitor ];
  };
}
