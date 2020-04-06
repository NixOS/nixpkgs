{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.opengl;

  kernelPackages = config.boot.kernelPackages;

  videoDrivers = config.services.xserver.videoDrivers;

  makePackage = p: pkgs.buildEnv {
    name = "mesa-drivers+txc-${p.mesa.version}";
    paths =
      [ p.mesa.drivers
        (if cfg.s3tcSupport then p.libtxc_dxtn else p.libtxc_dxtn_s2tc)
      ];
  };

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
    (mkRenamedOptionModule [ "services" "xserver" "vaapiDrivers" ] [ "hardware" "opengl" "extraPackages" ])
  ];

  options = {

    hardware.opengl = {
      enable = mkOption {
        description = ''
          Whether to enable OpenGL drivers. This is needed to enable
          OpenGL support in X11 systems, as well as for Wayland compositors
          like sway and Weston. It is enabled by default
          by the corresponding modules, so you do not usually have to
          set it yourself, only if there is no module for your wayland
          compositor of choice. See services.xserver.enable and
          programs.sway.enable.
        '';
        type = types.bool;
        default = false;
      };

      driSupport = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable accelerated OpenGL rendering through the
          Direct Rendering Interface (DRI).
        '';
      };

      driSupport32Bit = mkOption {
        type = types.bool;
        default = false;
        description = ''
          On 64-bit systems, whether to support Direct Rendering for
          32-bit applications (such as Wine).  This is currently only
          supported for the <literal>nvidia</literal> and
          <literal>ati_unfree</literal> drivers, as well as
          <literal>Mesa</literal>.
        '';
      };

      s3tcSupport = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Make S3TC(S3 Texture Compression) via libtxc_dxtn available
          to OpenGL drivers instead of the patent-free S2TC replacement.

          Using this library may require a patent license depending on your location.
        '';
      };

      package = mkOption {
        type = types.package;
        internal = true;
        description = ''
          The package that provides the OpenGL implementation.
        '';
      };

      package32 = mkOption {
        type = types.package;
        internal = true;
        description = ''
          The package that provides the 32-bit OpenGL implementation on
          64-bit systems. Used when <option>driSupport32Bit</option> is
          set.
        '';
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExample "with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ]";
        description = ''
          Additional packages to add to OpenGL drivers. This can be used
          to add OpenCL drivers, VA-API/VDPAU drivers etc.
        '';
      };

      extraPackages32 = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExample "with pkgs.pkgsi686Linux; [ vaapiIntel libvdpau-va-gl vaapiVdpau ]";
        description = ''
          Additional packages to add to 32-bit OpenGL drivers on
          64-bit systems. Used when <option>driSupport32Bit</option> is
          set. This can be used to add OpenCL drivers, VA-API/VDPAU drivers etc.
        '';
      };

      setLdLibraryPath = mkOption {
        type = types.bool;
        internal = true;
        default = false;
        description = ''
          Whether the <literal>LD_LIBRARY_PATH</literal> environment variable
          should be set to the locations of driver libraries. Drivers which
          rely on overriding libraries should set this to true. Drivers which
          support <literal>libglvnd</literal> and other dispatch libraries
          instead of overriding libraries should not set this.
        '';
      };
    };

  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.driSupport32Bit -> pkgs.stdenv.isx86_64;
        message = "Option driSupport32Bit only makes sense on a 64-bit system.";
      }
      { assertion = cfg.driSupport32Bit -> (config.boot.kernelPackages.kernel.features.ia32Emulation or false);
        message = "Option driSupport32Bit requires a kernel that supports 32bit emulation";
      }
    ];

    systemd.tmpfiles.rules = [
      "L+ /run/opengl-driver - - - - ${package}"
      (
        if pkgs.stdenv.isi686 then
          "L+ /run/opengl-driver-32 - - - - opengl-driver"
        else if cfg.driSupport32Bit then
          "L+ /run/opengl-driver-32 - - - - ${package32}"
        else
          "r /run/opengl-driver-32"
      )
    ];

    environment.sessionVariables.LD_LIBRARY_PATH = mkIf cfg.setLdLibraryPath
      ([ "/run/opengl-driver/lib" ] ++ optional cfg.driSupport32Bit "/run/opengl-driver-32/lib");

    hardware.opengl.package = mkDefault (makePackage pkgs);
    hardware.opengl.package32 = mkDefault (makePackage pkgs.pkgsi686Linux);

    boot.extraModulePackages = optional (elem "virtualbox" videoDrivers) kernelPackages.virtualboxGuestAdditions;
  };
}
