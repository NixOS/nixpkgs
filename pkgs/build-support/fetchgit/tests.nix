{
  runCommand,
  testers,
  fetchgit,
  nix-prefetch-git,
  jq,
  cacert,
  nix,
  closureInfo,
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

  # Make sure that if an expected hash is given and the corresponding store path exists already, no fetch is done
  cached-prefetch-avoids-fetch =
    let
      name = "cached-prefetch-avoids-fetch";
      url = "https://github.com/NixOS/nix";
      rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
      sha256 = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
      fetched = fetchgit {
        inherit
          name
          url
          rev
          sha256
          ;
      };
    in
    runCommand "cached-prefetch-avoids-fetch"
      {
        nativeBuildInputs = [
          nix-prefetch-git
          nix
        ];
      }
      ''
        export NIX_REMOTE=local?root=$(mktemp -d)
        nix-store --load-db < ${closureInfo { rootPaths = fetched; }}/registration
        nix-prefetch-git --name "${name}" "${url}" "${rev}" "${sha256}" > $out
      '';

  prefetch-git-no-add-path =
    testers.invalidateFetcherByDrvHash
      (
        {
          name,
          url,
          rev,
          hash,
          ...
        }:
        runCommand name
          {
            buildInputs = [
              nix-prefetch-git
              nix
              cacert
              jq
            ];
            outputHashMode = "recursive";
            outputHashAlgo = null;
            outputHash = hash;
            inherit url rev;
          }
          ''
            store_root="$(mktemp -d)"
            prefetch() { NIX_REMOTE="local?root=$store_root" nix-prefetch-git $@ "$url" --rev "$rev" | jq -r .path; }
            path="$(prefetch --no-add-path)"
            if test -e "$store_root/$path"; then
              echo "$path exists in $NIX_REMOTE when it shouldn't" >&2
              exit 1
            fi
            path_added="$(prefetch)"
            if ! test -e "$store_root/$path"; then
              echo "$path_added doesn't exist in NIX_REMOTE when it should" >&2
              exit 1
            fi
            if test "$path" != "$path_added"; then
              echo "Paths are different with and without --no-add-path: $path != $path_added" >&2
              exit 1
            fi
            cp -r "$store_root/$path_added" "$out"
          ''
      )
      {
        name = "nix-prefetch-git-no-add-path";
        url = "https://github.com/NixOS/nix";
        rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
        hash = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
      };

  withGitConfig =
    let
      pkgs = import ../../.. {
        config.gitConfig = {
          url."https://github.com".insteadOf = "https://doesntexist.forsure";
        };
      };
    in
    pkgs.testers.invalidateFetcherByDrvHash pkgs.fetchgit {
      name = "fetchgit-with-config";
      url = "https://doesntexist.forsure/NixOS/nix";
      rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
      sha256 = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
    };
}
