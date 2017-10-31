let requiredVersion = import ./lib/minver.nix; in

if ! builtins ? nixVersion || builtins.compareVersions requiredVersion builtins.nixVersion == 1 then

  abort ''

    This version of Nixpkgs requires Nix >= ${requiredVersion}, please upgrade:

    - If you are running NixOS, use `nixos-rebuild' to upgrade your system.

    - If you installed Nix using the install script (https://nixos.org/nix/install),
      it is safe to upgrade by running it again:

          curl https://nixos.org/nix/install | sh
  ''

else

  import ./pkgs/top-level/impure.nix
