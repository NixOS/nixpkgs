{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.impure-drivers;

  impurePath = pkgs.addDriverRunpath.driverLink;
  impurePath32 = pkgs.pkgsi686Linux.addDriverRunpath.driverLink;

  kernelPackages = config.boot.kernelPackages;

  videoDrivers = config.services.xserver.videoDrivers;

  package = pkgs.buildEnv {
    name = "opengl-drivers";
    paths = cfg.packages;
  };

  package32 = pkgs.buildEnv {
    name = "opengl-drivers-32bit";
    paths = cfg.packages32;
  };

in

{

  imports = [
    (mkRenamedOptionModule [ "services" "xserver" "vaapiDrivers" ] [ "hardware" "impure-drivers" "packages" ])
    (mkRemovedOptionModule [ "hardware" "opengl" "s3tcSupport" ] "S3TC support is now always enabled in Mesa.")

    # The old option `hardware.opengl.enable` corresponds to `hardware.impure-drivers.opengl.enable` (defaults to `true`).
    # However, in order support the transition of the systems that have been setting `hardware.opengl.enable`,
    # we need to translate it into `hardware.impure-drivers.enable` (defaults to `false`)
    (mkRenamedOptionModule [ "hardware" "opengl" "enable" ] [ "hardware" "impure-drivers" "enable" ])
    (mkRenamedOptionModule [ "hardware" "opengl" "extraPackages32" ] [ "hardware" "impure-drivers" "packages32" ])
    (mkRenamedOptionModule [ "hardware" "opengl" "extraPackages" ] [ "hardware" "impure-drivers" "packages" ])

    # Since we've treated `hardware.opengl.enable` specially, we cannot just use
    # `(mkRenamedOptionModule [ "hardware" "opengl" ] [ "hardware" "impure-drivers" "opengl" ])`.
    (mkRenamedOptionModule [ "hardware" "opengl" "driSupport32Bit" ] [ "hardware" "impure-drivers" "opengl" "driSupport32Bit" ])
    (mkRenamedOptionModule [ "hardware" "opengl" "driSupport" ] [ "hardware" "impure-drivers" "opengl" "driSupport" ])
    (mkRenamedOptionModule [ "hardware" "opengl" "package32" ] [ "hardware" "impure-drivers" "opengl" "package32" ])
    (mkRenamedOptionModule [ "hardware" "opengl" "package" ] [ "hardware" "impure-drivers" "opengl" "package" ])
    (mkRenamedOptionModule [ "hardware" "opengl" "setLdLibraryPath" ] [ "hardware" "impure-drivers" "setLdLibraryPath" ])
  ];

  options = {

    hardware.impure-drivers = {

      enable = mkEnableOption (lib.mdDoc ''
        Deploy user-space drivers in the impure location expected by Nixpkgs.
        This may be necessary to use graphical (OpenGL, Vulkan) or
        hardware-acclerated (CUDA) applications from Nixpkgs.

        ::: {.note}
        In the current implementation, this will create a directory at
        `/run/opengl-driver/lib` (`pkgs.addDriverRunpath.driverLink`),
        populated with symlinks to the enabled driver libraries.
        :::
      '');

      packages = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExpression "with pkgs; [ intel-media-driver intel-ocl intel-vaapi-driver config.hardware.nvidia.package ]";
        description = lib.mdDoc ''
          Packages to deploy in the user-space drivers' impure location.
          This can be used to add e.g. OpenCL, VA-API/VDPAU, or CUDA drivers.

          ::: {.note}
          intel-media-driver supports hardware Broadwell (2014) or newer. Older hardware should use the mostly unmaintained intel-vaapi-driver driver.
          :::
        '';
      };

      packages32 = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExpression "with pkgs.pkgsi686Linux; [ intel-media-driver intel-vaapi-driver ]";
        description = lib.mdDoc ''
          Packages to deploy in the 32-bit user-space drivers' impure location.
          Used when {option}`driSupport32Bit` is set. Cf. the documentation for [](#opt-hardware.impure-drivers.packages).
        '';
      };

      opengl.enable = mkOption {
        description = lib.mdDoc ''
          Whether to enable OpenGL drivers. This is needed to enable
          OpenGL support in X11 systems, as well as for Wayland compositors
          like sway and Weston. It is enabled by default
          by the corresponding modules, so you do not usually have to
          set it yourself, only if there is no module for your wayland
          compositor of choice. See services.xserver.enable and
          programs.sway.enable.
        '';
        type = types.bool;
        default = true;
      };

      opengl.driSupport = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable accelerated OpenGL rendering through the
          Direct Rendering Interface (DRI).
        '';
      };

      opengl.driSupport32Bit = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          On 64-bit systems, whether to support Direct Rendering for
          32-bit applications (such as Wine).  This is currently only
          supported for the `nvidia` as well as
          `Mesa`.
        '';
      };

      opengl.package = mkOption {
        type = types.package;
        internal = true;
        description = lib.mdDoc ''
          The package that provides the OpenGL implementation.
        '';
      };

      opengl.package32 = mkOption {
        type = types.package;
        internal = true;
        description = lib.mdDoc ''
          The package that provides the 32-bit OpenGL implementation on
          64-bit systems. Used when {option}`driSupport32Bit` is
          set.
        '';
      };

      setLdLibraryPath = mkOption {
        type = types.bool;
        internal = true;
        default = false;
        description = lib.mdDoc ''
          Whether the `LD_LIBRARY_PATH` environment variable
          should be set to the locations of driver libraries. Drivers which
          rely on overriding libraries should set this to true. Drivers which
          support `libglvnd` and other dispatch libraries
          instead of overriding libraries should not set this.
        '';
      };
    };

  };

  config = mkIf cfg.enable {
    assertions = mkIf cfg.opengl.enable [
      { assertion = cfg.opengl.driSupport32Bit -> pkgs.stdenv.isx86_64;
        message = "Option driSupport32Bit only makes sense on a 64-bit system.";
      }
      { assertion = cfg.opengl.driSupport32Bit -> (config.boot.kernelPackages.kernel.features.ia32Emulation or false);
        message = "Option driSupport32Bit requires a kernel that supports 32bit emulation";
      }
    ];

    systemd.tmpfiles.rules = [
      "L+ ${impurePath} - - - - ${package}"
      (
        if pkgs.stdenv.isi686 then
          "L+ ${impurePath32} - - - - ${impurePath}"
        else if cfg.opengl.driSupport32Bit then
          "L+ ${impurePath32} - - - - ${package32}"
        else
          "r ${impurePath32}"
      )
    ];

    environment.sessionVariables.LD_LIBRARY_PATH = mkIf cfg.setLdLibraryPath
      ([ "${impurePath}/lib" ] ++ optionals cfg.driSupport32Bit ["${impurePath32}/lib"]);

    hardware.impure-drivers.opengl.package = mkDefault pkgs.mesa.drivers;
    hardware.impure-drivers.opengl.package32 = mkDefault pkgs.pkgsi686Linux.mesa.drivers;

    hardware.impure-drivers.packages = mkIf cfg.opengl.enable [ cfg.opengl.package ];
    hardware.impure-drivers.packages32 = mkIf cfg.opengl.enable [ cfg.opengl.package32 ];

    boot.extraModulePackages = optional (elem "virtualbox" videoDrivers) kernelPackages.virtualboxGuestAdditions;
  };
}
