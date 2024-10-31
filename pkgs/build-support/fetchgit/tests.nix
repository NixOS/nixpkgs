{ testers, fetchgit, ... }: {
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
}
