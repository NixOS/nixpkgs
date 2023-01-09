{ pkgs }:
self: super: {

  nixops = super.nixops.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/NixOS/nixops.git";
        rev = "5013072c5ca34247d7dce545c3a7b1954948fd4d";
        sha256 = "0417xq7s0qkh9ali8grlahpxl4sgg4dla302dda4768wbp0wagcz";
      };
    }
  );

  nixops-aws = super.nixops-aws.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/NixOS/nixops-aws.git";
        rev = "d8a6679c413edd1a7075b2fe08017b4c7fa3b3ce";
        sha256 = "0aqkaskp6nkcnfxxf1n294xp4ggk36qldj5c3kzfgxim06jap7n5";
      };
    }
  );

  nixops-digitalocean = super.nixops-digitalocean.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/nix-community/nixops-digitalocean.git";
        rev = "e977b7f11e264a6a2bff2dcbc7b94c6a97b92fff";
        sha256 = "020fg1kjh3x57dj95micpq6mxjg5j50jy6cs5f10i33ayy3556v8";
      };
    }
  );

  nixops-encrypted-links = super.nixops-encrypted-links.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/nix-community/nixops-encrypted-links.git";
        rev = "e2f196fce15fcfb00d18c055e1ac53aec33b8fb1";
        sha256 = "12ynqwd5ad6wfyv6sma55wnmrlr8i14kd5d42zqv4zl23h0xnd6m";
      };
    }
  );

  nixops-gcp = super.nixops-gcp.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/nix-community/nixops-gce.git";
        rev = "712453027486e62e087b9c91e4a8a171eebb6ddd";
        sha256 = "0siw2silxvbxdfgb2dcymn11nqdf8an7q43wcq1lyg1ac07w7dwh";
      };
    }
  );

  nixops-hercules-ci = super.nixops-hercules-ci.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/hercules-ci/nixops-hercules-ci.git";
        rev = "e601d5baffd003fd5f22deeaea0cb96444b054dc";
        sha256 = "0rcpv5hc6l9ia8lq8ivwa80b2pwssmdz8an25lhr4i2472mpx1p0";
      };
    }
  );

  nixops-hetzner = super.nixops-hetzner.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/NixOS/nixops-hetzner";
        rev = "bc7a68070c7371468bcc8bf6e36baebc6bd2da35";
        sha256 = "0kmzv5dzh828yh5jwjs5klfslx3lklrqvpvbh29b398m5r9bbqkn";
      };
    }
  );

  nixops-hetznercloud = super.nixops-hetznercloud.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/lukebfox/nixops-hetznercloud.git";
        rev = "c00533400506d40940f7c1f67bf3973db37d9dd9";
        sha256 = "1xfwhiyay7x1r3q6rxn2f3h0llgwf73vl8fxp0ww13rgny2w0dgj";
      };
    }
  );

  nixops-virtd = super.nixops-virtd.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/nix-community/nixops-libvirtd.git";
        rev = "bc3cf1c5c774a80e05991ca040baa2b23e3ecd51";
        sha256 = "06bcxchjgmgfvhg9dzlcdnr4ak0h1rdpfpgbix3z2via2gad8bvj";
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
