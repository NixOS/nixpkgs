{ lib, ... }:

{
  options.module = lib.mkOption {
    type = lib.types.submodule { };
  };

  # Ensure definition value isn't used in undeclared option errors.
  config.module.doesnt_exist = abort "Value evaluated when it shouldn't be";
}
