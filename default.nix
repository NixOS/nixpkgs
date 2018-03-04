let requiredVersion = import ./lib/minver.nix; in

if ! builtins ? nixVersion || builtins.compareVersions requiredVersion builtins.nixVersion == 1 then

  abort ''

    This version of Nixpkgs requires Nix >= ${requiredVersion}, please upgrade:

    - If you are running NixOS, `nixos-rebuild' can be used to upgrade your system.

    - Alternatively, with Nix > 2.0 `nix upgrade-nix' can be used to imperatively
      upgrade Nix. You may use `nix-env --version' to check which version you have.

    - If you installed Nix using the install script (https://nixos.org/nix/install),
      it is safe to upgrade by running it again:

          curl https://nixos.org/nix/install | sh
  ''

else

  import ./pkgs/top-level/impure.nix
