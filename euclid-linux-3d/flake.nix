{
  description = "Euclid Linux 3D";

  inputs = {
    nixpkgs.url = "path:../"; # Use the surrounding nixpkgs checkout
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ (import ./overlays) ];
        config.allowUnfree = true;
      };
    in {
      overlays.default = import ./overlays;

      nixosConfigurations = {
        euclid-linux-3d-iso = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit self pkgs; };
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"
            ./modules/core/default.nix
            ./modules/branding/default.nix
            ./profiles/budgie-wayfire.nix
          ];
        };
      };

      packages.${system} = {
        inherit (pkgs)
          euclid-icon-theme
          euclid-welcome
          euclid-wayfire-session
          euclid-wallpapers;
      };

      # We provide an ISO output separately to avoid heavy builds during standard flake checks
      iso = {
        euclid-linux-3d-iso = self.nixosConfigurations.euclid-linux-3d-iso.config.system.build.isoImage;
      };
    };
}
