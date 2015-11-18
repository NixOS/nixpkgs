{ configuration ? import ./lib/from-env.nix "NIXOS_CONFIG" <nixos-config>
, system ? builtins.currentSystem
, extraModules ? []
  # This attribute is used to specify a different nixos version, a different
  # system or additional modules which might be set conditionally.
, reEnter ? false
}:

let
  reEnterModule = {
    config.nixos.path = with (import ../lib); mkIf reEnter (mkForce null);
    config.nixos.configuration = configuration;
  };

  eval = import ./lib/eval-config.nix {
    inherit system;
    modules = [ configuration reEnterModule ] ++ extraModules;
  };

  inherit (eval) pkgs;

  # This is for `nixos-rebuild build-vm'.
  vmConfig = (import ./lib/eval-config.nix {
    inherit system;
    modules = [ configuration reEnterModule ./modules/virtualisation/qemu-vm.nix ] ++ extraModules;
  }).config;

  # This is for `nixos-rebuild build-vm-with-bootloader'.
  vmWithBootLoaderConfig = (import ./lib/eval-config.nix {
    inherit system;
    modules =
      [ configuration reEnterModule
        ./modules/virtualisation/qemu-vm.nix
        { virtualisation.useBootLoader = true; }
      ];
  }).config;

in

{
  inherit (eval.config.nixos.reflect) config options;

  system = eval.config.system.build.toplevel;

  vm = vmConfig.system.build.vm;

  vmWithBootLoader = vmWithBootLoaderConfig.system.build.vm;

  # The following are used by nixos-rebuild.
  nixFallback = pkgs.nixUnstable;
}
