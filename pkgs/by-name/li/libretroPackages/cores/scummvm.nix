{
  lib,
  fetchFromGitHub,
  libGL,
  libGLU,
  which,
  zip,
  mkLibretroCore,
  coreutils,
  gnugrep,
  gnused,
  nix,
  unstableGitUpdater,
  writeShellApplication,
}:
let
  # NOTE: these are kept in sync with upstream by the updateScript below
  # https://github.com/libretro/scummvm/blob/e0ddc60bfabb1efdf1e135006c8914ca59d0596c/backends/platform/libretro/dependencies.mk#L8-L14
  libretro-common-src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-common";
    rev = "879c8d507b0b52e77e27d759239c2b5df1e26dfd";
    hash = "sha256-9nvZn3SrFHgMIu6VY5uOYpGuLRaWEz1nurYCRY/r/lg=";
  };

  libretro-deps-src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-deps";
    rev = "bab7d258c451c0e7cba4b6a79f1b062c13efff38";
    hash = "sha256-7qSTjtOHjJ3Ew0obZxZ8JY2v0kjgu0bg+x2DiCViwM8=";
  };
in
mkLibretroCore {
  core = "scummvm";
  version = "0-unstable-2026-10-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "scummvm";
    rev = "e0ddc60bfabb1efdf1e135006c8914ca59d0596c";
    hash = "sha256-K3p8BQ8FVjN71T+R6UK8o9Lhkr3RNpol4T9+3C+Kmdo=";
  };

  extraBuildInputs = [
    libGL
    libGLU
    zip
  ];

  extraNativeBuildInputs = [ which ];

  preConfigure = "cd backends/platform/libretro";

  preBuild = ''
    mkdir -p deps/libretro-{common,deps}
    cp -a ${libretro-common-src}/* deps/libretro-common
    cp -a ${libretro-deps-src}/* deps/libretro-deps
    chmod -R u+w deps/

    # Fix conflicts with glibc index/rindex functions
    sed -i 's/\bindex\b/faad_index/g; s/\brindex\b/faad_rindex/g' deps/libretro-deps/libfaad/libfaad/common.h

    patchShebangs ./scripts/*
  '';

  makefile = "Makefile";

  passthru.updateScript = [
    (lib.getExe (writeShellApplication {
      name = "update-libretro-scummvm";
      runtimeInputs = [
        coreutils
        gnugrep
        gnused
        nix
      ];
      text = ''
        ${lib.escapeShellArgs (unstableGitUpdater {
          hardcodeZeroVersion = true;
        })}

        core_file="pkgs/by-name/li/libretroPackages/cores/scummvm.nix"
        src=$(nix-build --no-out-link -A "$UPDATE_NIX_ATTR_PATH.src")
        src_rev=$(nix-instantiate --eval --raw -A "$UPDATE_NIX_ATTR_PATH.src.rev")
        deps_mk="$src/backends/platform/libretro/dependencies.mk"

        # keep the link to dependencies.mk pointing at the packaged revision
        sed -i -E "s|(libretro/scummvm/blob/)[0-9a-f]{40}/|\1$src_rev/|" "$core_file"

        for dep in libretro-common libretro-deps; do
          new_rev=$(sed -n -E "s/^DEPS_COMMIT_''${dep}[[:space:]]*:=[[:space:]]*([0-9a-f]{40}).*/\1/p" "$deps_mk")
          if [[ -z "$new_rev" ]]; then
            echo "error: DEPS_COMMIT_''${dep} not found in dependencies.mk" >&2
            exit 1
          fi

          fetch_block=$(grep -A2 "repo = \"$dep\";" "$core_file")
          old_rev=$(echo "$fetch_block" | sed -n -E 's/.*rev = "([0-9a-f]{40})".*/\1/p')
          old_hash=$(echo "$fetch_block" | sed -n -E 's/.*hash = "([^"]+)".*/\1/p')

          if [[ "$old_rev" == "$new_rev" ]]; then
            echo "$dep: already at $new_rev" >&2
            continue
          fi

          # fetchFromGitHub fetches the GitHub archive tarball
          new_hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri \
            "$(nix-prefetch-url --unpack "https://github.com/libretro/$dep/archive/$new_rev.tar.gz")")

          echo "$dep: $old_rev -> $new_rev" >&2
          sed -i "s|$old_rev|$new_rev|; s|$old_hash|$new_hash|" "$core_file"
        done
      '';
    }))
  ];

  meta = {
    description = "Libretro port of ScummVM";
    homepage = "https://github.com/libretro/scummvm";
    license = lib.licenses.gpl2Only;
  };
}
