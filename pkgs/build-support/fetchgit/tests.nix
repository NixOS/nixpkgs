{
  testers,
  fetchgit,
  fetchurl,
  ...
}:
{
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
    sha256 = "sha256-VmQ38+lr+rNPaTnjjV41uC2XSN4fkfZAfytE2uKyLfo=";
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
    sha256 = "sha256-EC2PMEEtA7f5OFdsluHn7pi4QXhCZuFML8tib4pV7Ek=";
    leaveDotGit = true;
    fetchSubmodules = true;
  };

  submodule-deep = testers.invalidateFetcherByDrvHash fetchgit {
    name = "submodule-deep-source";
    url = "https://github.com/pineapplehunter/nix-test-repo-with-submodule";
    rev = "26473335b84ead88ee0a3b649b1c7fa4a91cfd4a";
    sha256 = "sha256-3zWogs6EZBnzUfz6gBnigETTKGYl9KFKFgsy6Bl4DME=";
    deepClone = true;
    fetchSubmodules = true;
    # deepClone implies leaveDotGit, so delete the .git directory after
    # fetching to distinguish from the submodule-leave-git-deep test.
    postFetch = "rm -r $out/.git";
  };

  submodule-leave-git-deep = testers.invalidateFetcherByDrvHash fetchgit {
    name = "submodule-leave-git-deep-source";
    url = "https://github.com/pineapplehunter/nix-test-repo-with-submodule";
    rev = "26473335b84ead88ee0a3b649b1c7fa4a91cfd4a";
    sha256 = "sha256-ieYn9I/0RgeSwQkSqwKaU3RgjKFlRqMg7zw0Nvu3azA=";
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

  fetchTags = testers.invalidateFetcherByDrvHash fetchgit {
    name = "fetchgit-fetch-tags-test";
    url = "https://github.com/NixOS/nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    fetchTags = true;
    leaveDotGit = true;
    sha256 = "sha256-y7l+46lVP2pzJwGON5qEV0EoxWofRoWAym5q9VXvpc8=";
    postFetch = ''
      cd $out && git describe --tags --always > describe-output.txt 2>&1 || echo "git describe failed" > describe-output.txt
      # See https://github.com/NixOS/nixpkgs/issues/412967#issuecomment-2927452118
      rm -rf .git
    '';
  };

  rootDir = testers.invalidateFetcherByDrvHash fetchgit {
    name = "fetchgit-with-rootdir";
    url = "https://github.com/NixOS/nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    rootDir = "misc/systemd";
    sha256 = "sha256-UhxHk4SrXYq7ZDMtXLig5SigpbITrVgkpFTmryuvpcM=";
  };

  ssh-commit-verification = testers.invalidateFetcherByDrvHash fetchgit {
    name = "ssh-commit-verification-source";
    url = "https://codeberg.org/flandweber/git-verify";
    rev = "a43858e8f106b313aed68b6455a45340db7dd758";
    sha256 = "sha256-IH2ed4oRruhWkPorcEETmbzWpaqY6/tNSUUMk+ntZ3M=";
    verifyCommit = true;
    publicKeys = [
      {
        type = "ssh-ed25519";
        key = "AAAAC3NzaC1lZDI1NTE5AAAAIBiNDWMPZNRItkm1U1CQkJUUrrmM+l7CdE6wyUHzr4Nr";
      }
    ];
  };

  gpg-commit-verification = testers.invalidateFetcherByDrvHash fetchgit {
    name = "gpg-commit-verification-source";
    url = "https://gitlab.torproject.org/tpo/core/tor";
    rev = "8888e4ca6b44bb7476139be4644e739035441b35";
    sha256 = "sha256-HSYUwzm3k4GAIt/ds80i8HM8hZLgC7zTUJBqhF6wBvA=";
    verifyCommit = true;
    publicKeys = [
      {
        type = "gpg";
        key = fetchurl {
          url = "https://web.archive.org/web/20241109193517/https://keys.openpgp.org/vks/v1/by-fingerprint/5EF3A41171BB77E6110ED2D01F3D03348DB1A3E2";
          sha256 = "sha256-xvBWfaS1py7vyDIIYGtATqBOnWafd3B6OB2Blhfm4MU=";
        };
      }
    ];
  };

  gpg-tag-verification = testers.invalidateFetcherByDrvHash fetchgit {
    name = "gpg-tag-verification-source";
    url = "https://gitlab.torproject.org/tpo/core/tor";
    tag = "tor-0.4.8.12";
    sha256 = "sha256-AXVD5I7KyDVAPIOHcPRHHfW0uwPxjCuY9t1Bf/pBLps=";
    verifyTag = true;
    publicKeys = [
      {
        type = "gpg";
        key = fetchurl {
          url = "https://web.archive.org/web/20241109193821/https://keys.openpgp.org/vks/v1/by-fingerprint/B74417EDDF22AC9F9E90F49142E86A2A11F48D36";
          sha256 = "sha256-M4mvelY1nLeGuhgZIpF4oAe80kbJl2+wcDI6zp9YwXo=";
        };
      }
    ];
  };
}
