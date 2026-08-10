{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = inputs: {
    nixosConfigurations.example = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";

      modules = [ ../config ];
    };

    # Example of how one can override the host package set!
    varsConfigurations.differentArch =
      let
        pkgsHost = inputs.nixpkgs.legacyPackages.x86_64-linux;
      in
      pkgsHost.nixos-vars.jsonify {
        inherit pkgsHost;
        config = inputs.self.nixosConfigurations.example;
      };
  };
}
