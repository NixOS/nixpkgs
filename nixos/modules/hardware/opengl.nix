{ config, lib, pkgs, pkgs_i686, ... }:

with lib;

let

  cfg = config.hardware.opengl;

  kernelPackages = config.boot.kernelPackages;

  videoDrivers = config.services.xserver.videoDrivers;

  makePackage = p: pkgs.buildEnv {
    name = "mesa-drivers+txc-${p.mesa_drivers.version}";
    paths =
      [ p.mesa_drivers
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
  options = {

    hardware.opengl = {
      enable = mkOption {
        description = ''
          Whether to enable OpenGL drivers. This is needed to enable
          OpenGL support in X11 systems, as well as for Wayland compositors
          like sway, way-cooler and Weston. It is enabled by default
          by the corresponding modules, so you do not usually have to
          set it yourself, only if there is no module for your wayland
          compositor of choice. See services.xserver.enable,
          programs.sway.enable, and programs.way-cooler.enable.
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
    };

  };

  config = mkIf cfg.enable {

    assertions = lib.singleton {
      assertion = cfg.driSupport32Bit -> pkgs.stdenv.isx86_64;
      message = "Option driSupport32Bit only makes sense on a 64-bit system.";
    };

    system.activationScripts.setup-opengl =
      ''
        ln -sfn ${package} /run/opengl-driver
        ${if pkgs.stdenv.isi686 then ''
          ln -sfn opengl-driver /run/opengl-driver-32
        '' else if cfg.driSupport32Bit then ''
          ln -sfn ${package32} /run/opengl-driver-32
        '' else ''
          rm -f /run/opengl-driver-32
        ''}
      '';

    environment.sessionVariables.LD_LIBRARY_PATH =
      [ "/run/opengl-driver/lib" ] ++ optional cfg.driSupport32Bit "/run/opengl-driver-32/lib";

    environment.variables.XDG_DATA_DIRS =
      [ "/run/opengl-driver/share" ] ++ optional cfg.driSupport32Bit "/run/opengl-driver-32/share";

    hardware.opengl.package = mkDefault (makePackage pkgs);
    hardware.opengl.package32 = mkDefault (makePackage pkgs_i686);

    boot.extraModulePackages = optional (elem "virtualbox" videoDrivers) kernelPackages.virtualboxGuestAdditions;
  };
}
