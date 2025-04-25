{
  pkgs ? import ../.. { },
}:
let
  nixos = pkgs.nixosMinimal {
    fileSystems."/".device = "/dev/null";
    boot.loader.grub.enable = false;
  };
in

nixos.config.system.build.toplevel
