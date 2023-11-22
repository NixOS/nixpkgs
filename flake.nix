# Experimental flake interface to Nixpkgs.
# See https://github.com/NixOS/rfcs/pull/49 for details.
{
  description = "A collection of packages for the Nix package manager";

  outputs = { self }:
    let
      jobs = import ./pkgs/top-level/release.nix {
        nixpkgs = self;
      };

      lib = (import ./lib).extend (final: prev: {
        trivial = prev.trivial // {
          versionSuffix = let
            lastModified = final.substring 0 8 (toString
              (self.lastModifiedDate or self.lastModified or "19700101"));
            shortRev = self.shortRev or self.dirtyShortRev or "dirty";
          in ".${lastModified}.${shortRev}";

          revisionWithDefault = default: self.rev or self.dirtyRev or default;
        };
      });

      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      lib = lib // {
        nixos = import ./nixos/lib { inherit lib; };

        nixosSystem = args:
          import ./nixos/lib/eval-config.nix (
            { inherit lib; } // args // lib.optionalAttrs (! args?system) {
              # Allow system to be set modularly in nixpkgs.system.
              # We set it to null, to remove the "legacy" entrypoint's
              # non-hermetic default.
              system = null;
            }
          );
      };

      checks.x86_64-linux.tarball = jobs.tarball;

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
      legacyPackages = forAllSystems (system: import ./. {
        inherit system;
        overlays = [ (_: _: { inherit lib; }) ];
      });

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
