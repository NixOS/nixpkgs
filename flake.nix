# Experimental flake interface to Nixpkgs.
# See https://github.com/NixOS/rfcs/pull/49 for details.
{
  description = "A collection of packages for the Nix package manager";

  outputs = { self }:
    let

      jobs = import ./pkgs/top-level/release.nix {
        nixpkgs = self;
      };

      lib = import ./lib;

      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];

      forAllSystems = f: lib.genAttrs systems (system: f system);

    in
    {
      lib = lib.extend (final: prev: {
        nixosSystem = { modules, ... } @ args:
          import ./nixos/lib/eval-config.nix (args // {
            modules = modules ++
              [ { system.nixos.versionSuffix =
                    ".${final.substring 0 8 (self.lastModifiedDate or self.lastModified)}.${self.shortRev or "dirty"}";
                  system.nixos.revision = final.mkIf (self ? rev) self.rev;
                }
              ];
          });
      });

      checks.x86_64-linux.tarball = jobs.tarball;

      htmlDocs = {
        nixpkgsManual = jobs.manual;
        nixosManual = (import ./nixos/release-small.nix {
          nixpkgs = self;
        }).nixos.manual.x86_64-linux;
      };

      legacyPackages = forAllSystems (system: import ./. { inherit system; });

      nixosModules = {
        notDetected = import ./nixos/modules/installer/scan/not-detected.nix;
      };
    };
}
