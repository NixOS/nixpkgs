{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    # Guards the test/bench/libtess2/common helper targets behind
    # EARCUT_BUILD_*, which upstream's own CMakeLists.txt previously left
    # unconditionally defined even with those options off. Merged upstream:
    # https://github.com/mapbox/earcut.hpp/pull/139
    #
    # Our pinned rev predates that fix by 11 CMakeLists.txt-touching commits
    # (unrelated FetchContent/fixtures rework in between), so this fetches
    # the full CMakeLists.txt-only diff across that range instead of just
    # the one commit - the result is byte-identical to upstream master's
    # current CMakeLists.txt. Scoped to CMakeLists.txt only: none of the
    # other files in that range (algorithm, test fixtures) are pulled in.
    (fetchpatch2 {
      name = "guard-test-bench-viz-helper-targets.patch";
      url = "https://github.com/mapbox/earcut.hpp/compare/f36ced7e50254738c4e5af1a239f5fb7b1094007...2fbafada15dbe5350c606426e17111b91a964e55.diff";
      includes = [ "CMakeLists.txt" ];
      hash = "sha256-UIlHnJfY5bJRwxmwnwauIRQEkVpeYVyY8gdBoIIh9j4=";
    })
  ];

  # The real earcut_hpp target is a plain INTERFACE library - nothing to
  # compile - so skip building "all" entirely; install (which only needs
  # the configure step to have produced the export files) is all that's
  # needed.
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
