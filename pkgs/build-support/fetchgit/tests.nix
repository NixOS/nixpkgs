{ testers, fetchgit, fetchurl, ... }: {
  simple = testers.invalidateFetcherByDrvHash fetchgit {
    name = "simple-nix-source";
    url = "https://github.com/NixOS/nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    sha256 = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
  };

  sparseCheckout = testers.invalidateFetcherByDrvHash fetchgit {
    name = "sparse-checkout-nix-source";
    url = "https://github.com/NixOS/nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    sparseCheckout = [
      "src"
      "tests"
    ];
    sha256 = "sha256-g1PHGTWgAcd/+sXHo1o6AjVWCvC6HiocOfMbMh873LQ=";
  };

  sparseCheckoutNonConeMode = testers.invalidateFetcherByDrvHash fetchgit {
    name = "sparse-checkout-non-cone-nix-source";
    url = "https://github.com/NixOS/nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    sparseCheckout = [
      "src"
      "tests"
    ];
    nonConeMode = true;
    sha256 = "sha256-FknO6C/PSnMPfhUqObD4vsW4PhkwdmPa9blNzcNvJQ4=";
  };

  leave-git = testers.invalidateFetcherByDrvHash fetchgit {
    name = "leave-git-nix-source";
    url = "https://github.com/NixOS/nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    sha256 = "sha256-zZxDxqaeWvuWuzwPizBLR7d59zP24+zqnWllNICenko=";
    leaveDotGit = true;
  };

  submodule-simple = testers.invalidateFetcherByDrvHash fetchgit {
    name = "submodule-simple-source";
    url = "https://github.com/pineapplehunter/nix-test-repo-with-submodule";
    rev = "26473335b84ead88ee0a3b649b1c7fa4a91cfd4a";
    sha256 = "sha256-rmP8PQT0wJBopdtr/hsB7Y/L1G+ZPdHC2r9LB05Qrj4=";
    fetchSubmodules = true;
  };

  submodule-leave-git = testers.invalidateFetcherByDrvHash fetchgit {
    name = "submodule-leave-git-source";
    url = "https://github.com/pineapplehunter/nix-test-repo-with-submodule";
    rev = "26473335b84ead88ee0a3b649b1c7fa4a91cfd4a";
    sha256 = "sha256-+uXIClcRJ4S1rdgx2Oyww+Jv4h1VXp8tfeh9lb07Fhk=";
    leaveDotGit = true;
    fetchSubmodules = true;
  };

  submodule-deep = testers.invalidateFetcherByDrvHash fetchgit {
    name = "submodule-deep-source";
    url = "https://github.com/pineapplehunter/nix-test-repo-with-submodule";
    rev = "26473335b84ead88ee0a3b649b1c7fa4a91cfd4a";
    sha256 = "sha256-LL7uhXQk3N3DcvBBxwjmfVx55tTXCGQ19T91tknopzw=";
    deepClone = true;
    fetchSubmodules = true;
  };

  submodule-leave-git-deep = testers.invalidateFetcherByDrvHash fetchgit {
    name = "submodule-leave-git-deep-source";
    url = "https://github.com/pineapplehunter/nix-test-repo-with-submodule";
    rev = "26473335b84ead88ee0a3b649b1c7fa4a91cfd4a";
    sha256 = "sha256-LL7uhXQk3N3DcvBBxwjmfVx55tTXCGQ19T91tknopzw=";
    deepClone = true;
    leaveDotGit = true;
    fetchSubmodules = true;
  };

  dumb-http-signed-tag = testers.invalidateFetcherByDrvHash fetchgit {
    name = "dumb-http-signed-tag-source";
    url = "https://git.scottworley.com/pub/git/pinch";
    rev = "v3.0.14";
    sha256 = "sha256-bd0Lx75Gd1pcBJtwz5WGki7XoYSpqhinCT3a77wpY2c=";
  };

  ssh-commit-verification = testers.invalidateFetcherByDrvHash fetchgit {
    name = "ssh-commit-verification-source";
    url = "https://codeberg.org/flandweber/git-verify";
    rev = "a43858e8f106b313aed68b6455a45340db7dd758";
    sha256 = "sha256-tryIB8KlETlbHyTfW+IpsAgu2BQCcoeuHJpvzyFFsMg=";
    verifyCommit = true;
    publicKeys = [{
        type = "ssh-ed25519";
        key = "AAAAC3NzaC1lZDI1NTE5AAAAIBiNDWMPZNRItkm1U1CQkJUUrrmM+l7CdE6wyUHzr4Nr";
      }];
  };

  gpg-commit-verification = testers.invalidateFetcherByDrvHash fetchgit {
    name = "gpg-commit-verification-source";
    url = "https://gitlab.torproject.org/tpo/core/tor";
    rev = "8888e4ca6b44bb7476139be4644e739035441b35";
    sha256 = "sha256-mC18zGHAh/u9zcYMoYjgrQfsOtjp0UwfP4JXGZWzJHs=";
    verifyCommit = true;
    publicKeys = [{
        type="gpg";
        key= fetchurl {
          url = "https://keys.openpgp.org/vks/v1/by-fingerprint/5EF3A41171BB77E6110ED2D01F3D03348DB1A3E2";
          sha256 = "sha256-xvBWfaS1py7vyDIIYGtATqBOnWafd3B6OB2Blhfm4MU=";
        };
      }];
  };

  gpg-tag-verification = testers.invalidateFetcherByDrvHash fetchgit {
    name = "gpg-tag-verification-source";
    url = "https://gitlab.torproject.org/tpo/core/tor";
    rev = "tor-0.4.8.12";
    sha256 = "sha256-039kMxxf5B8FjOKoPjXie07+aQ3H8OauqAq62sU6LFo=";
    verifyTag = true;
    publicKeys = [{
        type="gpg";
        key= fetchurl {
          url = "https://keys.openpgp.org/vks/v1/by-fingerprint/B74417EDDF22AC9F9E90F49142E86A2A11F48D36";
          sha256 = "sha256-M4mvelY1nLeGuhgZIpF4oAe80kbJl2+wcDI6zp9YwXo=";
        };
      }];
  };

  gpg-tag-verification-refs-directory = testers.invalidateFetcherByDrvHash fetchgit {
    name = "gpg-tag-verification-source";
    url = "https://gitlab.torproject.org/tpo/core/tor";
    rev = "refs/tags/tor-0.4.8.12";
    sha256 = "sha256-039kMxxf5B8FjOKoPjXie07+aQ3H8OauqAq62sU6LFo=";
    verifyTag = true;
    publicKeys = [{
        type="gpg";
        key= fetchurl {
          url = "https://keys.openpgp.org/vks/v1/by-fingerprint/B74417EDDF22AC9F9E90F49142E86A2A11F48D36";
          sha256 = "sha256-M4mvelY1nLeGuhgZIpF4oAe80kbJl2+wcDI6zp9YwXo=";
        };
      }];
  };
}
