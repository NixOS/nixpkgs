{
  description = "Xnode OS";
  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    nixos-generators.url = "github:nix-community/nixos-generators";
  };
  outputs = inputs:
    let
      xnode =  import ./xnode.nix;
      flakeContext = {
        inherit xnode;
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
