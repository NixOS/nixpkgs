{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,

  # docs
  doxygen,
  graphviz,
  ghostscript,
  pdf2svg,
  pkg-config,
  texliveBasic,
  writableTmpDirAsHomeHook,

  # tests
  catch2_3,
  matio,
  python3Packages,
  simde,
  suitesparse,
}:

let
  doxygenTexlive = texliveBasic.withPackages (ps: [
    ps.newunicodechar
    ps.stmaryrd
    ps.xcolor
  ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "jrl-cmakemodules";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "jrl-umi3218";
    repo = "jrl-cmakemodules";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ty6PSQfIQK9jE9gaop2Rc+4uT0dG42A90+yU3pViLI0=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "JRL_CMAKEMODULES_GENERATE_API_DOC" true)
    (lib.cmakeBool "JRL_CMAKEMODULES_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  checkInputs = [
    catch2_3
    matio
    python3Packages.boost
    python3Packages.nanobind
    python3Packages.numpy
    python3Packages.pytest
    simde
    suitesparse
  ];

  passthru = {
    updateScript = nix-update-script { };
    docsNativeBuildInputs = [
      cmake
      doxygen
      doxygenTexlive
      graphviz
      ghostscript
      pdf2svg
      pkg-config
      writableTmpDirAsHomeHook
    ];
    docsCmakeFlags = [
      (lib.cmakeFeature "DOXYGEN_FORMULA_FONTSIZE" "13")
      (lib.cmakeFeature "DOXYGEN_HTML_FORMULA_FORMAT" "svg")
      (lib.cmakeFeature "DOXYGEN_HTML_OUTPUT" "doxygen-html")
      (lib.cmakeBool "DOXYGEN_USE_MATHJAX" false)
    ];
  };

  meta = {
    description = "CMake utility toolbox";
    homepage = "https://github.com/jrl-umi3218/jrl-cmakemodules";
    changelog = "https://github.com/jrl-umi3218/jrl-cmakemodules/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.all;
  };
})
