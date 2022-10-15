{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.drivers;

  kernelPackages = config.boot.kernelPackages;

  videoDrivers = config.hardware.gpu.drivers;

  drivers = pkgs.buildEnv {
    name = "hardware-drivers";
    paths = cfg.packages;
  };

  drivers32 = pkgs.buildEnv {
    name = "hardware-drivers-32bit";
    paths = cfg.packages32;
  };

in

{

  imports = [
    (mkRenamedOptionModule [ "hardware" "opengl" "enable" ] [ "hardware" "drivers" "enable" ])
    (mkRenamedOptionModule [ "hardware" "opengl" "package" ] [ "hardware" "drivers" "packages" ])
    (mkRenamedOptionModule [ "hardware" "opengl" "extraPackage" ] [ "hardware" "drivers" "packages" ])
    (mkRenamedOptionModule [ "hardware" "opengl" "driSupport32Bit" ] [ "hardware" "drivers" "enable32bit" ])
    (mkRenamedOptionModule [ "services" "xserver" "vaapiDrivers" ] [ "hardware" "drivers" "packages" ])
    (mkRemovedOptionModule [ "hardware" "opengl" "s3tcSupport" ] ''
      S3TC support is now always enabled in Mesa.
    '')
    (mkRemovedOptionModule [ "hardware" "opengl" "driSupport" ] ''
      dri support is now always enabled in Mesa.
    '')
  ];

  options = {

    hardware.drivers = {
      enable = mkOption {
        description = lib.mdDoc ''
          Whether to enable hardware drivers. This will include GPU and other
          hardware acceleration libraries. This is a requirement in X11 systems,
          as well as for Wayland compositors like sway and Weston. It is enabled by default
          by the corresponding modules, so you do not usually have to
          set it yourself, only if there is no module for your wayland
          compositor of choice. See services.xserver.enable and
          programs.sway.enable.
        '';
        type = types.bool;
        default = false;
      };

      enable32bit = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          On 64-bit systems, whether to include 32bit versions of drivers.
          Most useful for `wine` and downstream packages.
        '';
      };

      packages = mkOption {
        type = types.listOf types.package;
        example = literalExpression "with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ]";
        description = lib.mdDoc ''
          Hardware acceleration drivers.
        '';
      };

      packages32 = mkOption {
        type = types.listOf types.package;
        example = literalExpression "with pkgs.pkgsi686Linux; [ vaapiIntel libvdpau-va-gl vaapiVdpau ]";
        description = lib.mdDoc ''
          32 bit hardware acceleration drivers.
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

    assertions = [
      { assertion = cfg.enable32bit -> pkgs.stdenv.isx86_64;
        message = "Option enable32bit only makes sense on a 64-bit system.";
      }
      { assertion = cfg.enable32bit -> (config.boot.kernelPackages.kernel.features.ia32Emulation or false);
        message = "Option enable32bit requires a kernel that supports 32bit emulation";
      }
    ];

    # retain opengl-driver symlinks for backwards compatibility
    systemd.tmpfiles.rules = [
      "L+ /run/current-system/drivers - - - - ${drivers}"
      "L+ /run/opengl-driver - - - - hardware-drivers"
    ] ++ (if pkgs.stdenv.isi686 then [
      "L+ /run/current-system/drivers-32 - - - - hardware-drivers"
      "L+ /run/opengl-driver-32 - - - - hardware-drivers"
    ] else if cfg.enable32bit then [
      "L+ /run/current-system/drivers-32 - - - - ${drivers32}"
      "L+ /run/opengl-driver-32 - - - - ${drivers32}"
    ] else [
      "r /run/opengl-driver-32"
      "r /run/current-system/drivers-32"
    ]);

    environment.sessionVariables.LD_LIBRARY_PATH = mkIf cfg.setLdLibraryPath (
      [ "/run/current-system/drivers/lib" ]
      ++ optional cfg.enable32bit "/run/current-system/drivers-32/lib"
    );

    hardware.drivers.packages = mkDefault [ pkgs.mesa.drivers ];
    hardware.drivers.packages32 = mkDefault [ pkgs.pkgsi686Linux.mesa.drivers ];

    boot.extraModulePackages = optional (elem "virtualbox" videoDrivers) kernelPackages.virtualboxGuestAdditions;
  };
}
