{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkOption
    mkIf
    mkRemovedOptionModule
    mkEnableOption
    optional
    types
    ;

  this = config.hardware.acceleration;

  envFor =
    p:
    p.buildEnv {
      name = "drivers";
      paths = map (selector: selector p) this.packages;
    };
in

{
  options.hardware.acceleration = {
    packages = mkOption {
      type = with types; listOf packageSelector;
      description = ''
        Driver packages to be added to the global driver library path.

        If there is an option for your driver in {option}`hardware.drivers`, you should use that instead.
      '';
    };

    support32Bit =
      mkEnableOption "32 bit drivers usable by 32 bit applications"
      // mkOption { default = false; };
    setLdLibraryPath = mkOption {
      type = types.bool;
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
  imports = [
    # (mkRemovedOptionModule
    #   [
    #     "hardware"
    #     "opengl"
    #   ]
    #   "The hardware acceleration drivers have been refactored. Please use `hardware.acceleration` and `hardware.drivers` instead."
    # )
  ];

  config = mkIf (this.packages != [ ]) {
    assertions = [
      {
        assertion = this.support32Bit -> pkgs.stdenv.is64bit;
        message = "Option support32Bit only makes sense on a 64-bit system.";
      }
      {
        assertion =
          this.support32Bit -> (config.boot.kernelPackages.kernel.features.ia32Emulation or false);
        message = "Option support32Bit requires a kernel that supports 32bit emulation";
      }
    ];

    systemd.tmpfiles.rules = [
      "L+ /run/opengl-driver - - - - ${envFor pkgs}"
      (
        if pkgs.stdenv.is32bit then
          "L+ /run/opengl-driver-32 - - - - opengl-driver"
        else if this.support32Bit then
          "L+ /run/opengl-driver-32 - - - - ${envFor pkgs.pkgsi686Linux}"
        else
          "r /run/opengl-driver-32"
      )
    ];

    environment.sessionVariables.LD_LIBRARY_PATH = mkIf this.setLdLibraryPath (
      [ "/run/opengl-driver/lib" ] ++ optional this.support32Bit "/run/opengl-driver-32/lib"
    );
  };
}
