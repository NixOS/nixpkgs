{ lib, ... }:
let
  sub = {
    # An option named `config`; reason to have `onlyDefinesConfig = true;`
    options.config = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    config._module.args.bar = true;
  };
in
{
  options.submodule = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [ sub ];
      specialArgs.foo = true;
      onlyDefinesConfig = true;
    };
    default = { };
  };
}
