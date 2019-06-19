{
  name = "nixpkgs";

  epoch = 201906;

  description = "A collection of packages for the Nix package manager";

  outputs = inputs:
    let
      pkgs = import ./. { system = "x86_64-linux"; };
      jobs = import ./pkgs/top-level/release.nix {
        nixpkgs = inputs.self;
      };
    in
    {
      lib = (import ./lib) // {
        nixosSystem = import ./nixos/lib/eval-config.nix;
      };

      checks.tarball = jobs.tarball;

      builders = {
        inherit (pkgs) stdenv fetchurl;
      };

      htmlDocs = {
        nixpkgsManual = jobs.manual;
        nixosManual = (import ./nixos/release-small.nix {
          nixpkgs = inputs.self;
        }).nixos.manual.x86_64-linux;
      };

      packages = {
        inherit (pkgs) hello nix fuse nlohmann_json boost firefox;
      };

      legacyPackages = pkgs;
    };
}
