{ ... }:
let
  decFoo = "{ lib, ... }: { options.foo = lib.mkOption { default = 5; }; }";
  defFoo = "{ config.foo = 2; }";
in
{
  imports = [
    # works as a path object
    { outPath = ./declare-enable.nix; }
    # works as a string with context
    { outPath = "${builtins.toFile "decFoo" decFoo}"; }

    # __toString doesn't override outPath in the import
    {
      __toString = self: ./i-dont-exist.nix;
      outPath = ./define-enable.nix;
    }

    # other attributes in the set don't affect the import in any way
    {
      name = "definitions";
      some = "description";
      outPath = builtins.toFile "defFoo" defFoo;
    }
  ];
}
