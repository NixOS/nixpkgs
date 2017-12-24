{ lib, ... }:

{
  imports = [ ../. ];

  boot.kernel.sysctl = {
    "vm.laptop_mode" = lib.mkDefault 5;
  };

  services.tlp.enable = lib.mkDefault true;
}
