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
            ./profiles/lumina-compiz.nix
            ./profiles/mate-compiz.nix
            ./profiles/plasma.nix
          ];
        };
      };

      packages.${system} = {
        inherit (pkgs)
          compiz-bcop
          compiz-core
          compiz-plugins-main
          compiz-plugins-extra
          compiz-plugins-experimental
          libcompizconfig
          compizconfig-python
          ccsm
          simple-ccsm
          emerald
          emerald-themes
          fusion-icon
          compiz-manager
          euclid-icon-theme
          euclid-welcome
          euclid-wallpapers;

        compiz-reloaded-minimal = pkgs.symlinkJoin {
          name = "compiz-reloaded-minimal";
          paths = with pkgs; [ compiz-core compiz-plugins-main libcompizconfig compizconfig-python ccsm ];
        };

        compiz-reloaded-full = pkgs.symlinkJoin {
          name = "compiz-reloaded-full";
          paths = with pkgs; [ compiz-core compiz-plugins-main compiz-plugins-extra compiz-plugins-experimental libcompizconfig compizconfig-python ccsm simple-ccsm emerald emerald-themes fusion-icon compiz-manager ];
        };
      };

      # We provide an ISO output separately to avoid heavy builds during standard flake checks
      iso = {
        euclid-linux-3d-iso = self.nixosConfigurations.euclid-linux-3d-iso.config.system.build.isoImage;
      };
    };
}
