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
    types
    ;

  this = config.hardware.drivers;

  envFor =
    p:
    p.buildEnv {
      name = "drivers";
      paths = map (selector: selector p) this.packages;
    };
in

{
  options.hardware.drivers = {
    packages = mkOption {
      type = with types; listOf packageSelector;
      description = ''
        Driver packages to be added to the global driver library path.

        If there is an option for your driver in {option}`hardware.drivers`, you should use that instead.
      '';
      default = [ ];
      internal = true;
    };

    support32Bit =
      mkEnableOption ''
        On 64-bit systems, whether to also enable 32-bit drivers for use in 32-bit applications such as WINE.
      ''
      // mkOption { default = false; };
  };
  imports = [
    (lib.mkRenamedOptionModule [ "hardware" "graphics" "enable32Bit"] [ "hardware" "drivers" "support32Bit" ])
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

    systemd.tmpfiles.settings.graphics-driver = {
      "/run/opengl-driver"."L+".argument = toString (envFor pkgs);
      "/run/opengl-driver-32" =
        if pkgs.stdenv.hostPlatform.isi686 then
          { "L+".argument = "opengl-driver"; }
        else if this.support32Bit then
          { "L+".argument = toString (envFor pkgs.pkgsi686Linux); }
        else
          { "r" = { }; };
    };
  };
}
