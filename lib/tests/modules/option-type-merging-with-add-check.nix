{ lib, ... }:
let
  stringWithCheck = lib.types.addCheck lib.types.str (v: throw "Always fails. No value allowed.");
in
{
  imports = [
    {
      options.foo = lib.mkOption {
        type = stringWithCheck;
        default = "foo";
      };
    }
    {
      options.foo = lib.mkOption {
        type = stringWithCheck;
      };
    }
  ];
}
