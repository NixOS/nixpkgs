{ lib, ... }:
{
  options.value = lib.mkOption { default = 1; };
  imports = [ (lib.modules.importApply ./importApply-function.nix { foo = "abc"; }) ];
}
