{
  pkgs,
  ...
}:
let
  evalConfig = import ../lib/eval-config.nix;

  nixos = evalConfig {
    modules = [
      {
        system.stateVersion = "25.05";
        fileSystems."/".device = "/dev/null";
        boot.loader.grub.device = "nodev";
        nixpkgs.hostPlatform = pkgs.system;
        virtualisation.vmVariant.networking.hostName = "vm";
        virtualisation.vmVariantWithBootLoader.networking.hostName = "vm-w-bl";
      }
    ];
  };
in
assert nixos.config.virtualisation.vmVariant.networking.hostName == "vm";
assert nixos.config.virtualisation.vmVariantWithBootLoader.networking.hostName == "vm-w-bl";
assert nixos.config.networking.hostName == "nixos";
pkgs.symlinkJoin {
  name = "nixos-test-vm-variant-drvs";
  paths = with nixos.config.system.build; [
    toplevel
    vm
    vmWithBootLoader
  ];
}
