{ testers, fetchFromGitHub, ... }:
{
  simple = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "simple-nix-source";
    owner = "NixOS";
    repo = "nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    hash = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
  };

  sparseCheckout = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "sparse-checkout-nix-source";
    owner = "NixOS";
    repo = "nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    sparseCheckout = [
      "src"
      "tests"
    ];
    sha256 = "sha256-g1PHGTWgAcd/+sXHo1o6AjVWCvC6HiocOfMbMh873LQ=";
  };

  sparseCheckoutNonConeMode = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "sparse-checkout-non-cone-nix-source";
    owner = "NixOS";
    repo = "nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    sparseCheckout = [
      "src"
      "tests"
    ];
    nonConeMode = true;
    sha256 = "sha256-FknO6C/PSnMPfhUqObD4vsW4PhkwdmPa9blNzcNvJQ4=";
  };

  leave-git = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "leave-git-nix-source";
    owner = "NixOS";
    repo = "nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    sha256 = "sha256-VmQ38+lr+rNPaTnjjV41uC2XSN4fkfZAfytE2uKyLfo=";
    leaveDotGit = true;
  };

  submodule-simple = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "submodule-simple-source";
    owner = "pineapplehunter";
    repo = "nix-test-repo-with-submodule";
    rev = "26473335b84ead88ee0a3b649b1c7fa4a91cfd4a";
    sha256 = "sha256-rmP8PQT0wJBopdtr/hsB7Y/L1G+ZPdHC2r9LB05Qrj4=";
    fetchSubmodules = true;
  };

  submodule-leave-git = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "submodule-leave-git-source";
    owner = "pineapplehunter";
    repo = "nix-test-repo-with-submodule";
    rev = "26473335b84ead88ee0a3b649b1c7fa4a91cfd4a";
    sha256 = "sha256-EC2PMEEtA7f5OFdsluHn7pi4QXhCZuFML8tib4pV7Ek=";
    leaveDotGit = true;
    fetchSubmodules = true;
  };

  submodule-deep = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "submodule-deep-source";
    owner = "pineapplehunter";
    repo = "nix-test-repo-with-submodule";
    rev = "26473335b84ead88ee0a3b649b1c7fa4a91cfd4a";
    sha256 = "sha256-3zWogs6EZBnzUfz6gBnigETTKGYl9KFKFgsy6Bl4DME=";
    deepClone = true;
    fetchSubmodules = true;
    # deepClone implies leaveDotGit, so delete the .git directory after
    # fetching to distinguish from the submodule-leave-git-deep test.
    postFetch = "rm -r $out/.git";
  };

  submodule-leave-git-deep = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "submodule-leave-git-deep-source";
    owner = "pineapplehunter";
    repo = "nix-test-repo-with-submodule";
    rev = "26473335b84ead88ee0a3b649b1c7fa4a91cfd4a";
    sha256 = "sha256-ieYn9I/0RgeSwQkSqwKaU3RgjKFlRqMg7zw0Nvu3azA=";
    deepClone = true;
    leaveDotGit = true;
    fetchSubmodules = true;
  };

  dumb-http-signed-tag = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "dumb-http-signed-tag-source";
    owner = "NixOS";
    repo = "nix";
    tag = "2.9.2";
    sha256 = "sha256-uZCaBo9rdWRO/AlQMvVVjpAwzYijB2H5KKQqde6eHkg=";
  };

  fetchTags = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "fetchFromGitHub-fetch-tags-test";
    owner = "NixOS";
    repo = "nix";
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

  rootDir = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "fetchFromGitHub-with-rootdir";
    owner = "NixOS";
    repo = "nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    rootDir = "misc/systemd";
    hash = "sha256-UhxHk4SrXYq7ZDMtXLig5SigpbITrVgkpFTmryuvpcM=";
  };
}
