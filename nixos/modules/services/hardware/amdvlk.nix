{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.amdgpu.amdvlk;
in {
  options.hardware.amdgpu.amdvlk = {
    enable = lib.mkEnableOption "AMDVLK Vulkan driver";

    package = lib.mkPackageOption pkgs "amdvlk" { };

    supportExperimental.enable = lib.mkEnableOption "Experimental features support";

    support32Bit.enable = lib.mkEnableOption "32-bit driver support";
    support32Bit.package = lib.mkPackageOption pkgs [ "driversi686Linux" "amdvlk" ] { };

    settings = lib.mkOption {
      type = with lib.types; attrsOf (either str int);
      default = { };
      example = {
        AllowVkPipelineCachingToDisk = 1;
        ShaderCacheMode = 1;
        IFH = 0;
        EnableVmAlwaysValid = 1;
        IdleAfterSubmitGpuMask = 1;
      };
      description = ''
        Runtime settings for AMDVLK to be configured {file}`/etc/amd/amdVulkanSettings.cfg`.
        See [AMDVLK GitHub page](https://github.com/GPUOpen-Drivers/AMDVLK?tab=readme-ov-file#runtime-settings).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = [ cfg.package ];
      extraPackages32 = [ cfg.support32Bit.package ];
    };

    services.xserver.videoDrivers = [ "amdgpu" ];

    environment.sessionVariables = lib.mkIf cfg.supportExperimental.enable {
      AMDVLK_ENABLE_DEVELOPING_EXT = "all";
    };

    environment.etc = lib.mkIf (cfg.settings != { }) {
      "amd/amdVulkanSettings.cfg".text = lib.concatStrings
        (lib.mapAttrsToList
          (n: v: ''
            ${n},${builtins.toString v}
          '')
          cfg.settings);
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ johnrtitor ];
  };
}
