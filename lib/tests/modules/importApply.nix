{ lib, ... }: {
  options.value = lib.mkOption {
    default = 1;
  };
  imports = [
    (lib.importApply ./importApply-function.nix { foo = "abc"; })
  ];
}
