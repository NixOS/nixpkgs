import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "without-nix";
    meta = with lib.maintainers; {
      maintainers = [ ericson2314 ];
    };

    nodes.machine =
      { ... }:
      {
        nix.enable = false;
        nixpkgs.overlays = [
          (self: super: {
            nix = throw "don't want to use pkgs.nix";
            nixVersions = lib.mapAttrs (k: throw "don't want to use pkgs.nixVersions.${k}") super.nixVersions;
            # aliases, some deprecated
            nix_2_3 = throw "don't want to use pkgs.nix_2_3";
            nix_2_4 = throw "don't want to use pkgs.nix_2_4";
            nix_2_5 = throw "don't want to use pkgs.nix_2_5";
            nix_2_6 = throw "don't want to use pkgs.nix_2_6";
            nixFlakes = throw "don't want to use pkgs.nixFlakes";
            nixStable = throw "don't want to use pkgs.nixStable";
            nixUnstable = throw "don't want to use pkgs.nixUnstable";
            nixStatic = throw "don't want to use pkgs.nixStatic";
          })
        ];
      };

    testScript = ''
      start_all()

      machine.succeed("which which")
      machine.fail("which nix")
    '';
  }
)
