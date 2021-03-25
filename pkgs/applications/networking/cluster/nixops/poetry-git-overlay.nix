{ pkgs }:
self: super: {

  nixops = super.nixops.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/NixOS/nixops.git";
        rev = "1ed5a091bc52de6c91319f446f833018a1cb326e";
        sha256 = "1fx17qv9cl7hz7322zh4xlg02xn7bwwjj82cdcvqpsjf83crz3xi";
      };
    }
  );

  nixops-aws = super.nixops-aws.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/NixOS/nixops-aws.git";
        rev = "dbbaa1b15b6cf7ca1ceeb0a6195f5ee27693c505";
        sha256 = "13gw3h7g19a0s7dpayjfksrmw6g0364dcm5z2d6mlyzdkfgak4jn";
      };
    }
  );

  nixops-encrypted-links = super.nixops-encrypted-links.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/nix-community/nixops-encrypted-links.git";
        rev = "0bb9aa50a7294ee9dca10a18ff7d9024234913e1";
        sha256 = "00wj03wcry83acwljq5v80dyrqaxpqb4j3jsdkfy3d7n5g4aq19l";
      };
    }
  );

  nixops-gcp = super.nixops-gcp.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/nix-community/nixops-gce.git";
        rev = "23596af53eabc4e3bcf72beaaed82b2c8d40e419";
        sha256 = "10gfdhf4b3ldrpns8z66mqxwfcbgf9ccz8fx0rcp7gsgsffb0i3c";
      };
    }
  );

  nixops-virtd = super.nixops-virtd.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/nix-community/nixops-libvirtd.git";
        rev = "af6cf5b2ced57b7b6d36b5df7dd27a14e0a5cfb6";
        sha256 = "1j75yg8a44dlbig38mf7n7p71mdzff6ii1z1pdp32i4ivk3l0hy6";
      };
    }
  );

  nixopsvbox = super.nixopsvbox.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/nix-community/nixops-vbox.git";
        rev = "2729672865ebe2aa973c062a3fbddda8c1359da0";
        sha256 = "07bmrbg3g2prnba2kwg1rg6rvmnx1vzc538y2q3g04s958hala56";
      };
    }
  );

  nixos-modules-contrib = super.nixos-modules-contrib.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/nix-community/nixos-modules-contrib.git";
        rev = "81a1c2ef424dcf596a97b2e46a58ca73a1dd1ff8";
        sha256 = "0f6ra5r8i1jz8ymw6l3j68b676a1lv0466lv0xa6mi80k6v9457x";
      };
    }
  );

}
