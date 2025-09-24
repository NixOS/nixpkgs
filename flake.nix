# Experimental flake interface to Nixpkgs.
# See https://github.com/NixOS/rfcs/pull/49 for details.
{
  description = "A collection of packages for the Nix package manager";

  outputs =
    { self }:
    let
      libVersionInfoOverlay = import ./lib/flake-version-info.nix self;
      lib = (import ./lib).extend libVersionInfoOverlay;

      forAllSystems = lib.genAttrs lib.systems.flakeExposed;

      jobs = forAllSystems (
        system:
        import ./pkgs/top-level/release.nix {
          nixpkgs = self;
          inherit system;
        }
      );
    in
    {
      /**
        `nixpkgs.lib` is a combination of the [Nixpkgs library](https://nixos.org/manual/nixpkgs/unstable/#id-1.4), and other attributes
        that are _not_ part of the Nixpkgs library, but part of the Nixpkgs flake:

        - `lib.nixosSystem` for creating a NixOS system configuration

        - `lib.nixos` for other NixOS-provided functionality, such as [`runTest`](https://nixos.org/manual/nixos/unstable/#sec-call-nixos-test-outside-nixos)
      */
      # DON'T USE lib.extend TO ADD NEW FUNCTIONALITY.
      # THIS WAS A MISTAKE. See the warning in lib/default.nix.
      lib = lib.extend (
        final: prev: {

          /**
            Other NixOS-provided functionality, such as [`runTest`](https://nixos.org/manual/nixos/unstable/#sec-call-nixos-test-outside-nixos).
            See also `lib.nixosSystem`.
          */
          nixos = import ./nixos/lib { lib = final; };

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
            import ./nixos/lib/eval-config.nix (
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
                  (
                    {
                      config,
                      pkgs,
                      lib,
                      ...
                    }:
                    {
                      config.nixpkgs.flake.source = self.outPath;
                    }
                  )
                ];
              }
              // builtins.removeAttrs args [ "modules" ]
            );
        }
      );

      checks = forAllSystems (
        system:
        { }
        //
          lib.optionalAttrs
            (
              # Exclude x86_64-freebsd because "Failed to evaluate rustc-wrapper-1.85.0: «broken»: is marked as broken"
              system != "x86_64-freebsd"
            )
            {
              tarball = jobs.${system}.tarball;
            }
        //
          lib.optionalAttrs
            (
              self.legacyPackages.${system}.stdenv.hostPlatform.isLinux
              # Exclude power64 due to "libressl is not available on the requested hostPlatform" with hostPlatform being power64
              && !self.legacyPackages.${system}.targetPlatform.isPower64
              # Exclude armv6l-linux because "cannot bootstrap GHC on this platform ('armv6l-linux' with libc 'defaultLibc')"
              && system != "armv6l-linux"
              # Exclude riscv64-linux because "cannot bootstrap GHC on this platform ('riscv64-linux' with libc 'defaultLibc')"
              && system != "riscv64-linux"
            )
            {
              # Test that ensures that the nixosSystem function can accept a lib argument
              # Note: prefer not to extend or modify `lib`, especially if you want to share reusable modules
              #       alternatives include: `import` a file, or put a custom library in an option or in `_module.args.<libname>`
              nixosSystemAcceptsLib =
                (self.lib.nixosSystem {
                  pkgs = self.legacyPackages.${system};
                  lib = self.lib.extend (
                    final: prev: {
                      ifThisFunctionIsMissingTheTestFails = final.id;
                    }
                  );
                  modules = [
                    ./nixos/modules/profiles/minimal.nix
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
            }
      );

      htmlDocs = {
        nixpkgsManual = builtins.mapAttrs (_: jobSet: jobSet.manual) jobs;
        nixosManual =
          (import ./nixos/release-small.nix {
            nixpkgs = self;
          }).nixos.manual;
      };

      devShells = forAllSystems (
        system:
        { }
        //
          lib.optionalAttrs
            (
              # Exclude armv6l-linux because "Package ‘ghc-9.6.6’ in .../pkgs/development/compilers/ghc/common-hadrian.nix:579 is not available on the requested hostPlatform"
              system != "armv6l-linux"
              # Exclude riscv64-linux because "Package ‘ghc-9.6.6’ in .../pkgs/development/compilers/ghc/common-hadrian.nix:579 is not available on the requested hostPlatform"
              && system != "riscv64-linux"
              # Exclude x86_64-freebsd because "Package ‘ghc-9.6.6’ in .../pkgs/development/compilers/ghc/common-hadrian.nix:579 is not available on the requested hostPlatform"
              && system != "x86_64-freebsd"
            )
            {
              /**
                A shell to get tooling for Nixpkgs development. See nixpkgs/shell.nix.
              */
              default = import ./shell.nix { inherit system; };
            }
      );

      formatter = lib.filterAttrs (
        system: _:
        # Exclude armv6l-linux because "cannot bootstrap GHC on this platform ('armv6l-linux' with libc 'defaultLibc')"
        system != "armv6l-linux"
        # Exclude riscv64-linux because "cannot bootstrap GHC on this platform ('riscv64-linux' with libc 'defaultLibc')"
        && system != "riscv64-linux"
        # Exclude x86_64-freebsd because "Package ‘go-1.22.12-freebsd-amd64-bootstrap’ in /nix/store/0yw40qnrar3lvc5hax5n49abl57apjbn-source/pkgs/development/compilers/go/binary.nix:50 is not available on the requested hostPlatform"
        && system != "x86_64-freebsd"
      ) (forAllSystems (system: (import ./ci { inherit system; }).fmt.pkg));

      /**
        A nested structure of [packages](https://nix.dev/manual/nix/latest/glossary#package-attribute-set) and other values.

        The "legacy" in `legacyPackages` doesn't imply that the packages exposed
        through this attribute are "legacy" packages. Instead, `legacyPackages`
        is used here as a substitute attribute name for `packages`. The problem
        with `packages` is that it makes operations like `nix flake show
        nixpkgs` unusably slow due to the sheer number of packages the Nix CLI
        needs to evaluate. But when the Nix CLI sees a `legacyPackages`
        attribute it displays `omitted` instead of evaluating all packages,
        which keeps `nix flake show` on Nixpkgs reasonably fast, though less
        information rich.

        The reason why finding the tree structure of `legacyPackages` is slow,
        is that for each attribute in the tree, it is necessary to check whether
        the attribute value is a package or a package set that needs further
        evaluation. Evaluating the attribute value tends to require a significant
        amount of computation, even considering lazy evaluation.
      */
      legacyPackages = forAllSystems (
        system:
        (import ./. {
          inherit system;
          overlays = import ./pkgs/top-level/impure-overlays.nix ++ [
            (final: prev: {
              lib = prev.lib.extend libVersionInfoOverlay;
            })
          ];
        })
      );

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
        notDetected = ./nixos/modules/installer/scan/not-detected.nix;

        /**
          Make the `nixpkgs.*` configuration read-only. Guarantees that `pkgs`
          is the way you initialize it.

          Example:

              {
                imports = [ nixpkgs.nixosModules.readOnlyPkgs ];
                nixpkgs.pkgs = nixpkgs.legacyPackages.x86_64-linux;
              }
        */
        readOnlyPkgs = ./nixos/modules/misc/nixpkgs/read-only.nix;
      };
    };
}
