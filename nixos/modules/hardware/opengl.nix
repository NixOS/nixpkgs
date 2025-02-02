{ config, lib, pkgs, ... }:

let

  cfg = config.hardware.opengl;

  kernelPackages = config.boot.kernelPackages;

  videoDrivers = config.services.xserver.videoDrivers;

  package = pkgs.buildEnv {
    name = "opengl-drivers";
    paths = [ cfg.package ] ++ cfg.extraPackages;
  };

  package32 = pkgs.buildEnv {
    name = "opengl-drivers-32bit";
    paths = [ cfg.package32 ] ++ cfg.extraPackages32;
  };

in

{

  imports = [
    (lib.mkRenamedOptionModule [ "services" "xserver" "vaapiDrivers" ] [ "hardware" "opengl" "extraPackages" ])
    (lib.mkRemovedOptionModule [ "hardware" "opengl" "s3tcSupport" ] "S3TC support is now always enabled in Mesa.")
  ];

  options = {

    hardware.opengl = {
      enable = lib.mkOption {
        description = ''
          Whether to enable OpenGL drivers. This is needed to enable
          OpenGL support in X11 systems, as well as for Wayland compositors
          like sway and Weston. It is enabled by default
          by the corresponding modules, so you do not usually have to
          set it yourself, only if there is no module for your wayland
          compositor of choice. See services.xserver.enable and
          programs.sway.enable.
        '';
        type = lib.types.bool;
        default = false;
      };

      driSupport = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable accelerated OpenGL rendering through the
          Direct Rendering Interface (DRI).
        '';
      };

      driSupport32Bit = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          On 64-bit systems, whether to support Direct Rendering for
          32-bit applications (such as Wine).  This is currently only
          supported for the `nvidia` as well as
          `Mesa`.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        internal = true;
        description = ''
          The package that provides the OpenGL implementation.
        '';
      };

      package32 = lib.mkOption {
        type = lib.types.package;
        internal = true;
        description = ''
          The package that provides the 32-bit OpenGL implementation on
          64-bit systems. Used when {option}`driSupport32Bit` is
          set.
        '';
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        example = lib.literalExpression "with pkgs; [ intel-media-driver intel-ocl intel-vaapi-driver ]";
        description = ''
          Additional packages to add to OpenGL drivers.
          This can be used to add OpenCL drivers, VA-API/VDPAU drivers etc.

          ::: {.note}
          intel-media-driver supports hardware Broadwell (2014) or newer. Older hardware should use the mostly unmaintained intel-vaapi-driver driver.
          :::
        '';
      };

      extraPackages32 =lib. mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        example = lib.literalExpression "with pkgs.pkgsi686Linux; [ intel-media-driver intel-vaapi-driver ]";
        description = ''
          Additional packages to add to 32-bit OpenGL drivers on 64-bit systems.
          Used when {option}`driSupport32Bit` is set. This can be used to add OpenCL drivers, VA-API/VDPAU drivers etc.

          ::: {.note}
          intel-media-driver supports hardware Broadwell (2014) or newer. Older hardware should use the mostly unmaintained intel-vaapi-driver driver.
          :::
        '';
      };

      setLdLibraryPath = lib.mkOption {
        type = lib.types.bool;
        internal = true;
        default = false;
        description = ''
          Whether the `LD_LIBRARY_PATH` environment variable
          should be set to the locations of driver libraries. Drivers which
          rely on overriding libraries should set this to true. Drivers which
          support `libglvnd` and other dispatch libraries
          instead of overriding libraries should not set this.
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {
    assertions = [
      { assertion = cfg.driSupport32Bit -> pkgs.stdenv.isx86_64;
        message = "Option driSupport32Bit only makes sense on a 64-bit system.";
      }
      { assertion = cfg.driSupport32Bit -> (config.boot.kernelPackages.kernel.features.ia32Emulation or false);
        message = "Option driSupport32Bit requires a kernel that supports 32bit emulation";
      }
    ];

    systemd.tmpfiles.settings.opengl = {
      "/run/opengl-driver"."L+".argument = toString package;
      "/run/opengl-driver-32" =
        if pkgs.stdenv.isi686 then
          { "L+".argument = "opengl-driver"; }
        else if cfg.driSupport32Bit then
          { "L+".argument = toString package32; }
        else
          { "r" = {}; };
    };

    environment.sessionVariables.LD_LIBRARY_PATH = lib.mkIf cfg.setLdLibraryPath
      ([ "/run/opengl-driver/lib" ] ++ lib.optional cfg.driSupport32Bit "/run/opengl-driver-32/lib");

    hardware.opengl.package = lib.mkDefault pkgs.mesa.drivers;
    hardware.opengl.package32 = lib.mkDefault pkgs.pkgsi686Linux.mesa.drivers;

    boot.extraModulePackages = lib.optional (lib.elem "virtualbox" videoDrivers) kernelPackages.virtualboxGuestAdditions;
  };
}
