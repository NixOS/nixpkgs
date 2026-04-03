# Properties such as `mkDefault` at a nested level of `nestedAttrsOf`,
# for an element type without options.
{ lib, ... }:
{
  imports = [
    {
      value.a.b = lib.mkDefault 1;
      value.a.c = lib.mkIf true 3;
      value.d = lib.mkMerge [ { e = 4; } ];
    }
    { value.a.b = 2; }
  ];

  options.value = lib.mkOption {
    type = lib.types.nestedAttrsOf lib.types.int;
  };
}
