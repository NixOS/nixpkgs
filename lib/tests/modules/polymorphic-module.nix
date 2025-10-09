{ _class, lib, ... }:
let
  nixosModule =
    { ... }:
    {
      options.foo = lib.mkOption {
        default = "bar";
      };
    };
  darwinModule =
    { ... }:
    {
      options.bar = lib.mkOption {
        default = "foo";
      };
    };
in
{
  imports = [
    (lib.optionalAttrs (_class == "nixos") nixosModule)
    (lib.optionalAttrs (_class == "darwin") darwinModule)
  ];
}
