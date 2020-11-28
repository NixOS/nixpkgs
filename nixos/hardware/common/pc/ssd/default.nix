{ lib, ... }:

{
  boot.kernel.sysctl = {
    "vm.swappiness" = lib.mkDefault 1;
  };

  services.fstrim.enable = lib.mkDefault true;
}
