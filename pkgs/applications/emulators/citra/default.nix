# NOTICE: The company behind Citra was SLAPPed to death and was forced to nuke
# the upstream repos. This package is therefore without an active upstream and
# may break at any time. If you maintain a dependency of this package and yuzu
# broke because of a change in your package, please notify us maintainers and
# pay no further attention.

{ branch
, qt6Packages
, fetchFromGitHub
, fetchurl
}:

let
  # Fetched from https://api.citra-emu.org/gamedb
  # Please make sure to update this when updating citra!
  compat-list = fetchurl {
    name = "citra-compat-list";
    url = "https://web.archive.org/web/20231111133415/https://api.citra-emu.org/gamedb";
    hash = "sha256-J+zqtWde5NgK2QROvGewtXGRAWUTNSKHNMG6iu9m1fU=";
  };
in {
  nightly = qt6Packages.callPackage ./generic.nix rec {
    pname = "citra-nightly";
    version = "2088";

    src = fetchFromGitHub {
      owner = "PabloMK7";
      repo = "citra";
      rev = "480604ec72433f8cde3a8f6d22d3f8c86bea402f";
      sha256 = "0l9w4i0zbafcv2s6pd1zqb11vh0i7gzwbqnzlz9al6ihwbsgbj3k";
      fetchSubmodules = false; # We do fetch these but must substitute mirror URLs beforehand
      leaveDotGit = true;

      # We must use mirrors because upstream yuzu got nuked.
      # Sadly, the regular nix-prefetch-git doesn't support changing submodule urls.
      # This substitutes mirrors and fetches the submodules manually.
      postFetch = ''
        pushd $out
        # Git won't allow working on submodules otherwise...
        git restore --staged .

        cp .gitmodules{,.bak}

        substituteInPlace .gitmodules \
          --replace-fail yuzu-emu yuzu-emu-mirror \
          --replace-fail citra-emu PabloMK7 \
          --replace-fail merryhime yuzu-mirror \

        git submodule update --init --recursive -j ''${NIX_BUILD_CORES:-1} --progress --depth 1 --checkout --force

        mv .gitmodules{.bak,}

        # Remove .git dirs
        find . -name .git -type f -exec rm -rf {} +
        rm -rf .git/
        popd
      '';
    };

    inherit branch compat-list;
  };

  canary = qt6Packages.callPackage ./generic.nix rec {
    pname = "citra-canary";
    version = "2766";

    src = fetchFromGitHub {
      owner = "alessiot89";
      repo = "citrus-canary";
      rev = "canary-${version}";
      sha256 = "1gm3ajphpzwhm3qnchsx77jyl51za8yw3r0j0h8idf9y1ilcjvi4";
      fetchSubmodules = false; # We do fetch these but must substitute mirror URLs beforehand
      leaveDotGit = true;

      # We must use mirrors because upstream yuzu got nuked.
      # Sadly, the regular nix-prefetch-git doesn't support changing submodule urls.
      # This substitutes mirrors and fetches the submodules manually.
      postFetch = ''
        pushd $out
        # Git won't allow working on submodules otherwise...
        git restore --staged .

        cp .gitmodules{,.bak}

        substituteInPlace .gitmodules \
          --replace-fail yuzu-emu yuzu-emu-mirror \
          --replace-fail citra-emu PabloMK7 \
          --replace-fail merryhime yuzu-mirror \

        git submodule update --init --recursive -j ''${NIX_BUILD_CORES:-1} --progress --depth 1 --checkout --force

        mv .gitmodules{.bak,}

        # Remove .git dirs
        find . -name .git -type f -exec rm -rf {} +
        rm -rf .git/
        popd
      '';
    };

    inherit branch compat-list;
  };
}.${branch}
