{
  lib,
  coreutils,
  fetchFromGitHub,
  fmt_12,
  gitMinimal,
  glm,
  gnugrep,
  gnused,
  howard-hinnant-date,
  jq,
  libGL,
  libGLU,
  libslirp,
  mkLibretroCore,
  nix,
  nix-prefetch-git,
  cmake,
  span-lite,
  srcOnly,
  gitUpdater,
  writeShellApplication,
  zlib,
}:
let
  # NOTE: before changing the following fetches, see the updateScript below
  # https://github.com/JesseTG/melonds-ds/blob/main/cmake/FetchDependencies.cmake
  melonDS-src = fetchFromGitHub {
    owner = "JesseTG";
    repo = "melonDS";
    rev = "16f127dbb587a73371827ce79689c5d237c4b59b";
    hash = "sha256-55LrwWBPljMMoTOKsmZIBiVICFNm9Gr/GJlCvdKWUkA=";
  };
  libretro-common-src = fetchFromGitHub {
    owner = "JesseTG";
    repo = "libretro-common";
    rev = "fa8a1b572a444fcb552007019f8caf68281108aa";
    hash = "sha256-kI0hHiEr64wKvMF4di3rUMwoM2dEjEzpSPHFNILj6oE=";
  };
  embed-binaries-src = fetchFromGitHub {
    owner = "andoalon";
    repo = "embed-binaries";
    rev = "078b62beba97e8192c99bfb16d5e17220cfc7598";
    hash = "sha256-EkK+ZCbrZ2Y9wJ864OIwRWDfHcmxzKMco0QAkLOQOwY=";
  };
  pntr-src = fetchFromGitHub {
    owner = "robloach";
    repo = "pntr";
    rev = "a47fe167703b0ac3bfad00785b20b0dce6712509";
    hash = "sha256-DWYL0TI1UetbUD0qr/f0VZSu1JJvrBzqqT+m6ZfWraw=";
  };
  yamc-src = fetchFromGitHub {
    owner = "yohhoy";
    repo = "yamc";
    rev = "4e015a7e8eb0d61c34e6928676c8c78881a72d73";
    hash = "sha256-J5wAqF5yQ5KYArJJyKzaqscWsXq+KAPKXybYfVgasXs=";
  };
in
mkLibretroCore rec {
  core = "melondsds";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "JesseTG";
    repo = "melonds-ds";
    tag = "v${version}";
    hash = "sha256-bgtpomn/NnrxbuwSRfkWAcdG7AIZZAvTwK7sbveT3NM=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "find_package(Git REQUIRED)" ""

    substituteInPlace src/libretro/CMakeLists.txt \
      --replace-fail "include(embed-binaries)" "include(${embed-binaries-src}/cmake/embed-binaries.cmake)"
  '';

  makefile = "";
  extraBuildInputs = [
    libGL
    libGLU
  ];
  extraNativeBuildInputs = [ cmake ];
  cmakeFlags = [
    (lib.cmakeBool "ENABLE_LTO_RELEASE" false) # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=121831
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5") # required by yamc

    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MELONDS" "${melonDS-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBRETRO-COMMON" "${libretro-common-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_EMBED-BINARIES" "${embed-binaries-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GLM" "${glm.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ZLIB" "${srcOnly zlib}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBSLIRP" "${libslirp.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PNTR" "${pntr-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FMT" "${fmt_12.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_YAMC" "${yamc-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SPAN-LITE" "${span-lite.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DATE" "${howard-hinnant-date.src}")
  ];

  postBuild = "cd src/libretro";

  passthru.updateScript = [
    (lib.getExe (writeShellApplication {
      name = "update-libretro-melondsds";
      runtimeInputs = [
        coreutils
        gitMinimal
        gnugrep
        gnused
        jq
        nix
        nix-prefetch-git
      ];
      text = ''
        ${lib.escapeShellArgs (gitUpdater { rev-prefix = "v"; }).command}

        src=$(nix-build --no-out-link -A "$UPDATE_NIX_ATTR_PATH.src")
        core_file="pkgs/by-name/li/libretroPackages/cores/melondsds.nix"

        # find lines in the format:
        #   fetch_dependency(name url rev)
        # and extracts name, url and rev
        grep "^fetch_dependency" "''${src}/cmake/FetchDependencies.cmake" |
          sed 's/"//g' |
          sed 's/fetch_dependency(\(.*\))/\1/' |
          while read -r name url rev
          do
            echo >&2

            # example: if there is fetch_dependency(melonDS ...) and no melonDS-src
            if ! fetch_block=$(grep -A10 "''${name}-src =" "$core_file")
            then

              # if the dependency comes from nix, we just skip it
              if grep -q "FETCHCONTENT_SOURCE_DIR_''${name^^}" "$core_file"
              then
                echo "> skipped: ''${name} is provided by nixpkgs" >&2
                continue
              fi

              # otherwise, its a new dependency not specified on the config, and the updater can't continue
              echo "> ERROR: dependency missing: ''${name}" >&2
              exit 1
            fi

            echo "> ''${name}: ''${url} (''${rev})" >&2

            # dependencies may be pinned to a branch; resolve it to a commit
            if branch_rev=$(git ls-remote --exit-code "''${url}" "refs/heads/''${rev}" | cut -f1)
            then
              echo "> branch ''${rev} is at ''${branch_rev}" >&2
              rev="$branch_rev"
            fi

            prefetch=$(nix-prefetch-git --url "''${url}" --rev "''${rev}" --quiet)
            rev=$(echo "$prefetch" | jq -r ".rev")
            hash=$(echo "$prefetch" | jq -r ".hash")

            old_rev=$(echo "$fetch_block" | grep -m1 "rev =" | sed 's/\s*rev = "\(.*\)".*/\1/')
            old_hash=$(echo "$fetch_block" | grep -m1 "hash =" | sed 's/\s*hash = "\(.*\)".*/\1/')

            if [[ "$old_hash" == "$hash" ]]
            then
              echo "> skipped: same hash" >&2
              continue
            fi

            echo "rev - old: $old_rev" >&2
            echo "rev - new: $rev" >&2
            echo "hash - old: $old_hash" >&2
            echo "hash - new: $hash" >&2

            # finally replace old revision and old hash by the new one
            sed -i "s|$old_hash|$hash|" "$core_file"
            sed -i "s/$old_rev/$rev/" "$core_file"
          done
      '';
    }))
  ];

  meta = {
    description = "A remake of the libretro MelonDS core";
    homepage = "https://github.com/JesseTG/melonds-ds";
    changelog = "https://github.com/JesseTG/melonds-ds/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
  };
}
