# Experimental flake interface to Nixpkgs.
# See https://github.com/NixOS/rfcs/pull/49 for details.
{
  description = "A collection of packages for the Nix package manager";

  outputs = { self }:
    let
      lib = (import ./lib).extend (final: prev: {
        nixos = import ./nixos/lib { lib = final; };

        nixosSystem = args:
          import ./nixos/lib/eval-config.nix (
            args // {
              lib = args.lib or final;
              modules = args.modules ++ [{
                system.nixos.versionSuffix =
                  ".${final.substring 0 8 (self.lastModifiedDate or self.lastModified or "19700101")}.${self.shortRev or "dirty"}";
                system.nixos.revision = final.mkIf (self ? rev) self.rev;
              }];
            } // lib.optionalAttrs (! args?system) {
              # Allow system to be set modularly in nixpkgs.system.
              # We set it to null, to remove the "legacy" entrypoint's
              # non-hermetic default.
              system = null;
            }
          );
      });

      jobs = import ./pkgs/top-level/release.nix {
        inherit lib;
        nixpkgs = self;
      };

      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      inherit lib;

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
      legacyPackages = forAllSystems (system: import ./. { inherit system; });

      nixosModules = {
        notDetected = ./nixos/modules/installer/scan/not-detected.nix;
      };
    };
}
