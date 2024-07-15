{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { nixpkgs, self, ... } @ inputs: {
    nixosConfigurations."@hostname@" = nixpkgs.lib.nixosSystem {
      system = "@hostPlatformSystem@";
      modules = [
        ./configuration.nix
      ];
      specialArgs = {
        inherit inputs self;
      };
    };
  };
}
