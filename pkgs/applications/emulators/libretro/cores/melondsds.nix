{
  lib,
  applyPatches,
  coreutils,
  fetchFromGitHub,
  fmt_11,
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
  unstableGitUpdater,
  writeShellApplication,
}:
let
  # NOTE: before changing the following fetches, see the updateScript below
  # https://github.com/JesseTG/melonds-ds/blob/33c48260402865ef77667487528efd5ca7ce1233/cmake/FetchDependencies.cmake#L44
  melonDS-src = fetchFromGitHub {
    owner = "JesseTG";
    repo = "melonDS";
    rev = "f6692dff8c0c53f77639a08e5e746a286312bb41";
    hash = "sha256-+bMqpjspQzyRci3u0PEpR9oX3S9LBqP223y6VfI2j14=";
  };
  libretro-common-src = fetchFromGitHub {
    owner = "JesseTG";
    repo = "libretro-common";
    rev = "8e2b884db16711a999a0e46a02a3dc0be294b048";
    hash = "sha256-NYxi1BADUgMAtLfmYcOIhTAnmJ/LYd0OyfPKx6lorw4=";
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
    rev = "650237a524ea4fc953de7223a1587c83f2696794";
    hash = "sha256-qGWPlHkcW/wavxRN76SHiEKCl2b1VZR+O9YrZOFZL0I=";
  };
  yamc-src = fetchFromGitHub {
    owner = "yohhoy";
    repo = "yamc";
    rev = "4e015a7e8eb0d61c34e6928676c8c78881a72d73";
    hash = "sha256-J5wAqF5yQ5KYArJJyKzaqscWsXq+KAPKXybYfVgasXs=";
  };
  # using nixpkgs zlib gives a linking error
  zlib-src = applyPatches {
    src = fetchFromGitHub {
      owner = "madler";
      repo = "zlib";
      rev = "925af44f3cde53c6b076611c297850091b5dc7bb";
      hash = "sha256-TkPLWSN5QcPlL9D0kc/yhH0/puE9bFND24aj5NVDKYs=";
    };
    patches = [ ./patches/melondsds-zlib-no-zconf-rename.patch ];
  };
in
mkLibretroCore rec {
  core = "melondsds";
  version = "0-unstable-2026-03-03";

  src = fetchFromGitHub {
    owner = "JesseTG";
    repo = "melonds-ds";
    rev = "bac0256dc6a8736c5a228f57c562257e45fd49f3";
    hash = "sha256-EeXYibPV9BPazC/i5UqXEd4BKlIZbNbPNgpsoo4ws7k=";
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
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ZLIB" "${zlib-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBSLIRP" "${libslirp.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PNTR" "${pntr-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FMT" "${fmt_11.src}")
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
        gnugrep
        gnused
        jq
        nix
        nix-prefetch-git
      ];
      text = ''
        ${lib.escapeShellArgs (unstableGitUpdater {
          hardcodeZeroVersion = true;
        })}

        src=$(nix-build --no-out-link -A "$UPDATE_NIX_ATTR_PATH.src")
        core_file="pkgs/applications/emulators/libretro/cores/melondsds.nix"

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
