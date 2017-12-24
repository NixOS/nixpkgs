{ lib, ... }:

{
  boot.kernel.sysctl = {
    "vm.swappiness" = lib.mkDefault 10;
  };
}
