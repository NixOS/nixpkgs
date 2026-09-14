{ lib, ... }:
{
  options.value = lib.mkOption { default = 1; };
  imports = [
    (lib.modules.importApply { outPath = ./importApply-function.nix; } { foo = "bcd"; })
  ];
}
