{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.graphics;

  driversEnv = pkgs.buildEnv {
    name = "graphics-drivers";
    paths = [ cfg.package ] ++ cfg.extraPackages;
  };

  driversEnv32 = pkgs.buildEnv {
    name = "graphics-drivers-32bit";
    paths = [ cfg.package32 ] ++ cfg.extraPackages32;
  };
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "xserver" "vaapiDrivers" ] [ "hardware" "graphics" "extraPackages" ])
    (lib.mkRemovedOptionModule [ "hardware" "opengl" "s3tcSupport" ] "S3TC support is now always enabled in Mesa.")
    (lib.mkRemovedOptionModule [ "hardware" "opengl" "driSupport"] "The setting can be removed.")

    (lib.mkRenamedOptionModule [ "hardware" "opengl" "enable"] [ "hardware" "graphics" "enable" ])
    (lib.mkRenamedOptionModule [ "hardware" "opengl" "driSupport32Bit"] [ "hardware" "graphics" "enable32Bit" ])
    (lib.mkRenamedOptionModule [ "hardware" "opengl" "package"] [ "hardware" "graphics" "package" ])
    (lib.mkRenamedOptionModule [ "hardware" "opengl" "package32"] [ "hardware" "graphics" "package32" ])
    (lib.mkRenamedOptionModule [ "hardware" "opengl" "extraPackages"] [ "hardware" "graphics" "extraPackages" ])
    (lib.mkRenamedOptionModule [ "hardware" "opengl" "extraPackages32"] [ "hardware" "graphics" "extraPackages32" ])
  ];

  options.hardware.graphics = {
    enable = lib.mkOption {
      description = ''
        Whether to enable hardware accelerated graphics drivers.

        This is required to allow most graphical applications and
        environments to use hardware rendering, video encode/decode
        acceleration, etc.

        This option should be enabled by default by the corresponding modules,
        so you do not usually have to set it yourself.
      '';
      type = lib.types.bool;
      default = false;
    };

    enable32Bit = lib.mkOption {
      description = ''
        On 64-bit systems, whether to also install 32-bit drivers for
        32-bit applications (such as Wine).
      '';
      type = lib.types.bool;
      default = false;
    };

    package = lib.mkOption {
      description = ''
        The package that provides the default driver set.
      '';
      type = lib.types.package;
      internal = true;
    };

    package32 = lib.mkOption {
      description = ''
        The package that provides the 32-bit driver set. Used when {option}`enable32Bit` is enabled.
        set.
      '';
      type = lib.types.package;
      internal = true;
    };

    extraPackages = lib.mkOption {
      description = ''
        Additional packages to add to the default graphics driver lookup path.
        This can be used to add OpenCL drivers, VA-API/VDPAU drivers, etc.

        ::: {.note}
        intel-media-driver supports hardware Broadwell (2014) or newer. Older hardware should use the mostly unmaintained intel-vaapi-driver driver.
        :::
      '';
      type = lib.types.listOf lib.types.package;
      default = [];
      example = lib.literalExpression "with pkgs; [ intel-media-driver intel-ocl intel-vaapi-driver ]";
    };

    extraPackages32 = lib.mkOption {
      description = ''
        Additional packages to add to 32-bit graphics driver lookup path on 64-bit systems.
        Used when {option}`enable32Bit` is set. This can be used to add OpenCL drivers, VA-API/VDPAU drivers, etc.

        ::: {.note}
        intel-media-driver supports hardware Broadwell (2014) or newer. Older hardware should use the mostly unmaintained intel-vaapi-driver driver.
        :::
      '';
      type = lib.types.listOf lib.types.package;
      default = [];
      example = lib.literalExpression "with pkgs.pkgsi686Linux; [ intel-media-driver intel-vaapi-driver ]";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable32Bit -> pkgs.stdenv.hostPlatform.isx86_64;
        message = "`hardware.graphics.enable32Bit` only makes sense on a 64-bit system.";
      }
      {
        assertion = cfg.enable32Bit -> (config.boot.kernelPackages.kernel.features.ia32Emulation or false);
        message = "`hardware.graphics.enable32Bit` requires a kernel that supports 32-bit emulation";
      }
    ];

    systemd.tmpfiles.settings.graphics-driver = {
      "/run/opengl-driver"."L+".argument = toString driversEnv;
      "/run/opengl-driver-32" =
        if pkgs.stdenv.hostPlatform.isi686 then
          { "L+".argument = "opengl-driver"; }
        else if cfg.enable32Bit then
          { "L+".argument = toString driversEnv32; }
        else
          { "r" = {}; };
    };

    hardware.graphics.package = lib.mkDefault pkgs.mesa.drivers;
    hardware.graphics.package32 = lib.mkDefault pkgs.pkgsi686Linux.mesa.drivers;
  };
}
