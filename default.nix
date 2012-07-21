{ configuration ? import ./lib/from-env.nix "NIXOS_CONFIG" <nixos-config>
, extraModulesPath ? builtins.getEnv "NIXOS_EXTRA_MODULES" 
, system ? builtins.currentSystem
}:

let

  extraModules = if extraModulesPath == "" then [] else import extraModulesPath;

  eval = import ./lib/eval-config.nix {
    inherit system;
    modules = [ configuration ] ++ extraModules;
  };

  inherit (eval) config pkgs;

  # This is for `nixos-rebuild build-vm'.
  vmConfig = (import ./lib/eval-config.nix {
    inherit system;
    modules = [ configuration ./modules/virtualisation/qemu-vm.nix ] ++ extraModules;
  }).config;

  # This is for `nixos-rebuild build-vm-with-bootloader'.
  vmWithBootLoaderConfig = (import ./lib/eval-config.nix {
    inherit system;
    modules =
      [ configuration
        ./modules/virtualisation/qemu-vm.nix
        { virtualisation.useBootLoader = true; }
      ] ++ extraModules;
  }).config;

in

{
  inherit eval config;

  system = config.system.build.toplevel;

  vm = vmConfig.system.build.vm;

  vmWithBootLoader = vmWithBootLoaderConfig.system.build.vm;

  # The following are used by nixos-rebuild.
  nixFallback = pkgs.nixUnstable;
  manifests = config.installer.manifests;

  tests = config.tests;
}
