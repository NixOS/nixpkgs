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
        p.mesa_noglu # mainly for libGL
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
    hardware.opengl.enable = mkOption {
      description = "Whether this configuration requires OpenGL.";
      type = types.bool;
      default = false;
      internal = true;
    };

    hardware.opengl.driSupport = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable accelerated OpenGL rendering through the
        Direct Rendering Interface (DRI).
      '';
    };

    hardware.opengl.driSupport32Bit = mkOption {
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

    hardware.opengl.s3tcSupport = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Make S3TC(S3 Texture Compression) via libtxc_dxtn available
        to OpenGL drivers instead of the patent-free S2TC replacement.

        Using this library may require a patent license depending on your location.
      '';
    };

    hardware.opengl.package = mkOption {
      type = types.package;
      internal = true;
      description = ''
        The package that provides the OpenGL implementation.
      '';
    };

    hardware.opengl.package32 = mkOption {
      type = types.package;
      internal = true;
      description = ''
        The package that provides the 32-bit OpenGL implementation on
        64-bit systems. Used when <option>driSupport32Bit</option> is
        set.
      '';
    };

    hardware.opengl.extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExample "with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ]";
      description = ''
        Additional packages to add to OpenGL drivers. This can be used
        to add additional VA-API/VDPAU drivers.
      '';
    };

    hardware.opengl.extraPackages32 = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExample "with pkgs.pkgsi686Linux; [ vaapiIntel libvdpau-va-gl vaapiVdpau ]";
      description = ''
        Additional packages to add to 32-bit OpenGL drivers on
        64-bit systems. Used when <option>driSupport32Bit</option> is
        set. This can be used to add additional VA-API/VDPAU drivers.
      '';
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
      [ "/run/opengl-driver/lib" "/run/opengl-driver-32/lib" ];

    hardware.opengl.package = mkDefault (makePackage pkgs);
    hardware.opengl.package32 = mkDefault (makePackage pkgs_i686);

    boot.extraModulePackages = optional (elem "virtualbox" videoDrivers) kernelPackages.virtualboxGuestAdditions;
  };
}
