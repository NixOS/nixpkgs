{ config, lib, pkgs, pkgs_i686, ... }:

with lib;

let

  cfg = config.hardware.opengl;

  kernelPackages = config.boot.kernelPackages;

  videoDrivers = config.services.xserver.videoDrivers;

  makePackage = p: p.buildEnv {
    name = "mesa-drivers+txc-${p.mesa_drivers.version}";
    paths =
      [ p.mesa_drivers
        p.mesa_noglu # mainly for libGL
        (if cfg.s3tcSupport then p.libtxc_dxtn else p.libtxc_dxtn_s2tc)
        p.udev
      ];
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
        supported for the <literal>nvidia</literal> driver and for
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
        64-bit systems.  Used when <option>driSupport32Bit</option> is
        set.
      '';
    };

  };

  config = mkIf cfg.enable {

    assertions = pkgs.lib.singleton {
      assertion = cfg.driSupport32Bit -> pkgs.stdenv.isx86_64;
      message = "Option driSupport32Bit only makes sense on a 64-bit system.";
    };

    system.activationScripts.setup-opengl =
      ''
        ln -sfn ${cfg.package} /run/opengl-driver
        ${if pkgs.stdenv.isi686 then ''
          ln -sfn opengl-driver /run/opengl-driver-32
        '' else if cfg.driSupport32Bit then ''
          ln -sfn ${cfg.package32} /run/opengl-driver-32
        '' else ''
          rm -f /run/opengl-driver-32
        ''}
      '';

    environment.sessionVariables.LD_LIBRARY_PATH =
      [ "/run/opengl-driver/lib" "/run/opengl-driver-32/lib" ];

    # FIXME: move this into card-specific modules.
    hardware.opengl.package = mkDefault
      (if elem "ati_unfree" videoDrivers then
        kernelPackages.ati_drivers_x11
      else
        makePackage pkgs);

    hardware.opengl.package32 = mkDefault (makePackage pkgs_i686);

    boot.extraModulePackages =
      optional (elem "virtualbox" videoDrivers) kernelPackages.virtualboxGuestAdditions ++
      optional (elem "ati_unfree" videoDrivers) kernelPackages.ati_drivers_x11;

    environment.etc =
      optionalAttrs (elem "ati_unfree" videoDrivers) {
        "ati".source = "${kernelPackages.ati_drivers_x11}/etc/ati";
      };
  };
}
