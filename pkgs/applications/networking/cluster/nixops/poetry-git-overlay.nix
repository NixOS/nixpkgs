{ pkgs }:
self: super: {

  nixops = super.nixops.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/NixOS/nixops.git";
        rev = "fc9b55c55da62f949028143b974f67fdc7f40c8b";
        sha256 = "0f5r17rq3rf3ylp16cq50prn8qmfc1gwpqgqfj491w38sr5sspf8";
      };
    }
  );

  nixops-aws = super.nixops-aws.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/NixOS/nixops-aws.git";
        rev = "8802d1cda9004ec1362815292c2a8ab95e6d64e8";
        sha256 = "1rf2dxn4gdm9a91jji4f100y62ap3p3svs6qhxf78319phba6hlb";
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
        rev = "d13cb794aef763338f544010ceb1816fe31d7f42";
        sha256 = "0i57qhiga4nr0ms9gj615l599vxy78lzw7hap4rbzbhl5bl1yijj";
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
        rev = "e14f340f7ffe9e2aa7ffbaac0b8a2e3b4cc116b3";
        sha256 = "0vhapgzhqfk3y8a26ck09g0ilydsbjlx5g77f8bscdqz818lki12";
      };
    }
  );

  nixops-virtd = super.nixops-virtd.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/nix-community/nixops-libvirtd.git";
        rev = "be1ea32e02d8abb3dbe1b09b7c5a7419a7412991";
        sha256 = "1mklm3lmicvhs0vcib3ss21an45wk24m1mkcwy1zvbpbmvhdz2m4";
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
