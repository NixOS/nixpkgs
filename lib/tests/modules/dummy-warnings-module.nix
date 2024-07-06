{ lib, ... }:

{
  options.warnings = lib.mkOption {
    internal = true;
    default = [];
    type = lib.types.listOf lib.types.str;
    example = [ "The `foo' service is deprecated and will go away soon!" ];
    description = ''
      This option allows modules to show warnings to users during
      the evaluation of the system configuration.
    '';
  };
}
