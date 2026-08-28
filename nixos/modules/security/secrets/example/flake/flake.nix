{
  inputs.nixpkgs.url = "github:starlitcanopy/nixpkgs?ref=master";

  outputs = inputs: {
    nixosConfigurations.example = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";

      modules = [ ../basic-config ];
    };

    # Example of how one can override the host package set!
    secretConfigurations.differentArch =
      let
        pkgsHost = inputs.nixpkgs.legacyPackages.x86_64-linux;
      in
      pkgsHost.nixos-secrets.jsonify {
        inherit pkgsHost;
        configuration = inputs.self.nixosConfigurations.example;
      };
  };
}
