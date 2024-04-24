# Experimental flake interface to Nixpkgs.
# See https://github.com/NixOS/rfcs/pull/49 for details.
{
  description = "A collection of packages for the Nix package manager";

  outputs = { self }:
    let
      jobs = import ./pkgs/top-level/release.nix {
        nixpkgs = self;
      };

      libVersionInfoOverlay = import ./lib/flake-version-info.nix self;
      lib = (import ./lib).extend libVersionInfoOverlay;

      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      lib = lib.extend (final: prev: {

        nixos = import ./nixos/lib { lib = final; };

        nixosSystem = args:
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
                ({ config, pkgs, lib, ... }: {
                  config.nixpkgs.flake.source = self.outPath;
                })
              ];
            } // builtins.removeAttrs args [ "modules" ]
          );
      });

      checks.x86_64-linux = {
        tarball = jobs.tarball;
        # Test that ensures that the nixosSystem function can accept a lib argument
        # Note: prefer not to extend or modify `lib`, especially if you want to share reusable modules
        #       alternatives include: `import` a file, or put a custom library in an option or in `_module.args.<libname>`
        nixosSystemAcceptsLib = (self.lib.nixosSystem {
          lib = self.lib.extend (final: prev: {
            ifThisFunctionIsMissingTheTestFails = final.id;
          });
          modules = [
            ./nixos/modules/profiles/minimal.nix
            ({ lib, ... }: lib.ifThisFunctionIsMissingTheTestFails {
              # Define a minimal config without eval warnings
              nixpkgs.hostPlatform = "x86_64-linux";
              boot.loader.grub.enable = false;
              fileSystems."/".device = "nodev";
              # See https://search.nixos.org/options?show=system.stateVersion&query=stateversion
              system.stateVersion = lib.versions.majorMinor lib.version; # DON'T do this in real configs!
            })
          ];
        }).config.system.build.toplevel;
      };

      htmlDocs = {
        nixpkgsManual = jobs.manual;
        nixosManual = (import ./nixos/release-small.nix {
          nixpkgs = self;
        }).nixos.manual.x86_64-linux;
      };

      # The "legacy" in `legacyPackages` doesn't imply that the packages exposed
      # through this attribute are "legacy" packages. Instead, `legacyPackages`
      # is used here as a substitute attribute name for `packages`. The problem
      # with `packages` is that it makes operations like `nix flake show
      # nixpkgs` unusably slow due to the sheer number of packages the Nix CLI
      # needs to evaluate. But when the Nix CLI sees a `legacyPackages`
      # attribute it displays `omitted` instead of evaluating all packages,
      # which keeps `nix flake show` on Nixpkgs reasonably fast, though less
      # information rich.
      legacyPackages = forAllSystems (system:
        (import ./. { inherit system; }).extend (final: prev: {
          lib = prev.lib.extend libVersionInfoOverlay;
        })
      );

      nixosModules = {
        notDetected = ./nixos/modules/installer/scan/not-detected.nix;

        /*
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
