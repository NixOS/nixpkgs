{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = inputs: {
    nixosConfigurations.example = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";

      modules = [
        ../../nix_vars/nix/module.nix
        ../config.nix
      ];
    };

    varsConfigurations.differentArch = import ../../nix_vars/nix/jsonify.nix {
      config = inputs.self.nixosConfigurations.example;
      pkgsHost = inputs.nixpkgs.legacyPackages.x86_64-linux;
    };
  };
}
