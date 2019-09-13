{
  epoch = 201909;

  description = "A collection of packages for the Nix package manager";

  outputs = { self }:
    let
      pkgs = import ./. { system = "x86_64-linux"; };
      jobs = import ./pkgs/top-level/release.nix {
        nixpkgs = self;
      };
      lib = import ./lib;
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

      builders = {
        inherit (pkgs) stdenv fetchurl;
      };

      htmlDocs = {
        nixpkgsManual = jobs.manual;
        nixosManual = (import ./nixos/release-small.nix {
          nixpkgs = self;
        }).nixos.manual.x86_64-linux;
      };

      packages = {
        inherit (pkgs) hello nix fuse nlohmann_json boost firefox;
      };

      legacyPackages = pkgs;
    };
}
