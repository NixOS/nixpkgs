{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "earcut-hpp";
  version = "0-unstable-2025-09-18";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "earcut.hpp";
    rev = "f36ced7e50254738c4e5af1a239f5fb7b1094007";
    hash = "sha256-hsi4pvgCf9qg70QNYFHh8NO58Wclf15sXv227IoA8vg=";
  };

  cmakeFlags = [
    (lib.cmakeBool "EARCUT_BUILD_TESTS" false)
    (lib.cmakeBool "EARCUT_BUILD_BENCH" false)
    (lib.cmakeBool "EARCUT_BUILD_VIZ" false)
  ];

  # Upstream's own CMakeLists.txt leaves its test/bench/viz helper libraries
  # (fixtures/comparison/libtess2) unconditionally defined even with the
  # above options off, which would otherwise pull them (and libtess2's own
  # sources) into the default "all" target. The real earcut_hpp target is a
  # plain INTERFACE library - nothing to compile - so skip building "all"
  # entirely; install (which only needs the configure step to have produced
  # the export files) is all that's needed.
  dontBuild = true;

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Fast, header-only polygon triangulation library";
    homepage = "https://github.com/mapbox/earcut.hpp";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
