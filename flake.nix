{
  edition = 201909;

  description = "A collection of packages for the Nix package manager";

  outputs = { self }:
    let

      jobs = import ./pkgs/top-level/release.nix {
        nixpkgs = self;
      };

      lib = import ./lib;

      systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" ];

      forAllSystems = f: lib.genAttrs systems (system: f system);

    in
    {
      lib = lib // {
        nixosSystem = { modules, ... } @ args:
          import ./nixos/lib/eval-config.nix (args // {
            modules = modules ++
              [ { system.nixos.versionSuffix =
                    ".${lib.substring 0 8 self.lastModified}.${self.shortRev}";
                  system.nixos.revision = self.rev;
                }
              ];
          });
      };

      checks.tarball = jobs.tarball;

      htmlDocs = {
        nixpkgsManual = jobs.manual;
        nixosManual = (import ./nixos/release-small.nix {
          nixpkgs = self;
        }).nixos.manual.x86_64-linux;
      };

      legacyPackages = forAllSystems (system: import ./. { inherit system; });

      nixosModules = {
        notDetected = ./nixos/modules/installer/scan/not-detected.nix;
      };
    };
}
