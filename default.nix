let requiredVersion = import ./lib/minver.nix; in

if ! builtins ? nixVersion || builtins.compareVersions requiredVersion builtins.nixVersion == 1 then
   let
    fallback-paths = import ./nixos/modules/installer/tools/nix-fallback-paths.nix;

   in abort ''

    This version of Nixpkgs requires Nix >= ${requiredVersion}, please upgrade:

    - If you are running NixOS, `nixos-rebuild' can be used to upgrade your system.

    - If you have a multi-user Nix installation on macOS, update Nix by running:

          sudo -i nix-store -r ${fallback-paths.x86_64-darwin};
          sudo -i ${fallback-paths.x86_64-darwin}/bin/nix-env --uninstall nix
          sudo -i ${fallback-paths.x86_64-darwin}/bin/nix-env -i ${fallback-paths.x86_64-darwin}
          sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
          sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist

        if you have done that and still see this error message, also run:

          ${fallback-paths.x86_64-darwin}/bin/nix-env -i ${fallback-paths.x86_64-darwin}

    - If you installed Nix using the install script (https://nixos.org/nix/install),
      it is safe to upgrade by running it again:

          curl https://nixos.org/nix/install | sh

    For more information, please see the NixOS release notes at
    https://nixos.org/nixos/manual or locally at
    ${toString ./doc/manual/release-notes}.

    If you need further help, see https://nixos.org/nixos/support.html
  ''

else

  import ./pkgs/top-level/impure.nix
