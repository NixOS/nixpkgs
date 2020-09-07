{ lib, ... }:
let inherit (lib) types;
in {
  options.value = lib.mkOption {
    type = types.attrsOf (types.attrsOf (types.submodule ({ name, nameStack, ... }: {
      options.name = lib.mkOption { default = name; };
      options.nameStack = lib.mkOption { default = nameStack; };
    })));
  };

  config.value = {
    foo.bar = {};
  };
}
