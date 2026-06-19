{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = inputs: {
    nixosConfigurations.example = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ../../src/nix/module.nix
        ../config.nix
      ];
    };

    varsConfigurations.differentTargetArch = import ../../src/nix/jsonify.nix {
      config = inputs.self.nixosConfigurations.example;
      pkgsTarget = inputs.nixpks.legacyPackages.aarch64-linux;
    };
  };
}
