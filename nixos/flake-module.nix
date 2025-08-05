{
  config,
  lib,
  self,
  ...
}:
{
  perSystem.module =
    psArgs@{ system, ... }:
    {
      # Test that ensures that the nixosSystem function can accept a lib argument
      # Note: prefer not to extend or modify `lib`, especially if you want to share reusable modules
      #       alternatives include: `import` a file, or put a custom library in an option or in `_module.args.<libname>`
      checks =
        lib.mkIf
          (
            psArgs.config.legacyPackages.stdenv.hostPlatform.isLinux
            # Exclude power64 due to "libressl is not available on the requested hostPlatform" with hostPlatform being power64
            && !psArgs.config.legacyPackages.targetPlatform.isPower64
            # Exclude armv6l-linux because "cannot bootstrap GHC on this platform ('armv6l-linux' with libc 'defaultLibc')"
            && system != "armv6l-linux"
            # Exclude riscv64-linux because "cannot bootstrap GHC on this platform ('riscv64-linux' with libc 'defaultLibc')"
            && system != "riscv64-linux"
          )
          {
            nixosSystemAcceptsLib =
              (config.outputs.lib.nixosSystem {
                pkgs = psArgs.config.legacyPackages;
                lib = config.outputs.lib.extend (
                  final: prev: {
                    ifThisFunctionIsMissingTheTestFails = final.id;
                  }
                );
                modules = [
                  ./modules/profiles/minimal.nix
                  (
                    { lib, ... }:
                    lib.ifThisFunctionIsMissingTheTestFails {
                      # Define a minimal config without eval warnings
                      nixpkgs.hostPlatform = "x86_64-linux";
                      boot.loader.grub.enable = false;
                      fileSystems."/".device = "nodev";
                      # See https://search.nixos.org/options?show=system.stateVersion&query=stateversion
                      system.stateVersion = lib.trivial.release; # DON'T do this in real configs!
                    }
                  )
                ];
              }).config.system.build.toplevel;
          };
    };

  outputs = {
    htmlDocs.nixosManual =
      (import ./release-small.nix {
        nixpkgs = self;
      }).nixos.manual;

    /**
      Optional modules that can be imported into a NixOS configuration.

      Example:

          # flake.nix
          outputs = { nixpkgs, ... }: {
            nixosConfigurations = {
              foo = nixpkgs.lib.nixosSystem {
                modules = [
                  ./foo/configuration.nix
                  nixpkgs.nixosModules.notDetected
                ];
              };
            };
          };
    */
    nixosModules = {
      notDetected = ./modules/installer/scan/not-detected.nix;

      /**
        Make the `nixpkgs.*` configuration read-only. Guarantees that `pkgs`
        is the way you initialize it.

        Example:

            {
              imports = [ nixpkgs.nixosModules.readOnlyPkgs ];
              nixpkgs.pkgs = nixpkgs.legacyPackages.x86_64-linux;
            }
      */
      readOnlyPkgs = ./modules/misc/nixpkgs/read-only.nix;
    };
  };

  lib.overlays = [
    (final: prev: {
      /**
        Other NixOS-provided functionality, such as [`runTest`](https://nixos.org/manual/nixos/unstable/#sec-call-nixos-test-outside-nixos).
        See also `lib.nixosSystem`.
      */
      nixos = import ./lib { lib = final; };

      /**
        Create a NixOS system configuration.

        Example:

            lib.nixosSystem {
              modules = [ ./configuration.nix ];
            }

        Inputs:

        - `modules` (list of paths or inline modules): The NixOS modules to include in the system configuration.

        - `specialArgs` (attribute set): Extra arguments to pass to all modules, that are available in `imports` but can not be extended or overridden by the `modules`.

        - `modulesLocation` (path): A default location for modules that aren't passed by path, used for error messages.

        Legacy inputs:

        - `system`: Legacy alias for `nixpkgs.hostPlatform`, but this is already set in the generated `hardware-configuration.nix`, included by `configuration.nix`.
        - `pkgs`: Legacy alias for `nixpkgs.pkgs`; use `nixpkgs.pkgs` and `nixosModules.readOnlyPkgs` instead.
      */
      nixosSystem =
        args:
        import ./lib/eval-config.nix (
          {
            lib = final;
            # Allow system to be set modularly in nixpkgs.system.
            # We set it to null, to remove the "legacy" entrypoint's
            # non-hermetic default.
            system = null;

            modules = args.modules ++ [
              # This module is injected here since it exposes the nixpkgs self-path in as
              # constrained of contexts as possible to avoid more things depending on it and
              # introducing unnecessary potential fragility to changes in flakes itself.
              #
              # See: failed attempt to make pkgs.path not copy when using flakes:
              # https://github.com/NixOS/nixpkgs/pull/153594#issuecomment-1023287913
              {
                config.nixpkgs.flake.source = self.outPath;
              }
            ];
          }
          // builtins.removeAttrs args [ "modules" ]
        );
    })
  ];
}
