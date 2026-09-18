{ lib, ... }:
let
  myconf = lib.evalModules { modules = [ { } ]; };
in
{
  options.foo = lib.mkOption {
    type = lib.types.submodule { };
    default = { };
  };
  config.foo =
    { ... }:
    {
      imports = [
        # error, like `import-configuration.nix`, but in a submodule this time
        myconf
      ];
    };
}
