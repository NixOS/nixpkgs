/**
  Simulate a migration from a single-instance `services.foo` to a multi instance
  `services.foos.<name>` module, where `name = ""` serves as the legacy /
  compatibility instance.

  - No instances must exist, unless one is defined in the multi-instance module,
  or if the legacy enable option is set to true.
  - The legacy instance options must be renamed to the new instance, if it exists.

  The relevant scenarios are tested in separate files:
  - ./doRename-condition-enable.nix
  - ./doRename-condition-no-enable.nix
*/
{ config, lib, ... }:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    doRename
    ;
in
{
  options = {
    services.foo.enable = mkEnableOption "foo";
    services.foos = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            bar = mkOption { type = types.str; };
          };
        }
      );
      default = { };
    };
    result = mkOption { };
  };
  imports = [
    (doRename {
      from = [
        "services"
        "foo"
        "bar"
      ];
      to = [
        "services"
        "foos"
        ""
        "bar"
      ];
      visible = true;
      warn = false;
      use = x: x;
      withPriority = true;
      condition = config.services.foo.enable;
    })
  ];
}
