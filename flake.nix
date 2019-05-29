{
  name = "nixpkgs";

  epoch = 2019;

  description = "A collection of packages for the Nix package manager";

  provides = flakes:
    let pkgs = import ./. { system = "x86_64-linux"; }; in
    {
      lib = (import ./lib) // {
        nixosSystem = import ./nixos/lib/eval-config.nix;
      };

      builders = {
        inherit (pkgs) stdenv fetchurl;
      };

      packages = {
        inherit (pkgs) hello nix fuse nlohmann_json boost firefox;
      };

      legacyPackages = pkgs;
    };
}
