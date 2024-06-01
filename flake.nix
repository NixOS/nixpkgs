{
  description = "Xnode OS";
  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    nixos-generators.url = "github:nix-community/nixos-generators";
  };
  outputs = inputs:
    let
      flakeContext = {
        inherit inputs;
      };
    in
    {
      packages = {
        x86_64-linux = {
          iso = import ./packages/iso.nix flakeContext;
          netboot = import ./packages/netboot.nix flakeContext;
        };
      };
    };
}
