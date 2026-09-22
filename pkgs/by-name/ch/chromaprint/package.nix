{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  ninja,
  ffmpeg-headless,
  zlib,
  testers,
  validatePkgConfig,
  nix-update-script,
  withExamples ? true,
  withTools ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chromaprint";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "acoustid";
    repo = "chromaprint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Es903zeZ++9/Xb/npUU3rB0V87DVqwT9uTMbQdSzfJI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    validatePkgConfig
  ];

  buildInputs = [
    ffmpeg-headless
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    zlib
  ];

  # with trivialautovarinit enabled can produce an empty .pc file
  hardeningDisable = [ "trivialautovarinit" ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TOOLS" withTools)
  ]
  ++ lib.optionals (!finalAttrs.finalPackage.doCheck) [
    # special-cased to avoid a mass-rebuild: remove from `lib.optionals` as part of next update
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  # From some reason it dies at the end...
  doCheck = !stdenv.hostPlatform.isDarwin;
  checkPhase =
    let
      exampleAudio = fetchurl {
        name = "Dvorak_Symphony_9_1.mp3";
        url = "https://archive.org/download/Dvorak_Symphony_9/01.Adagio-Allegro_Molto.mp3";
        hash = "sha256-I+Ve3/OpL+3Joc928F8M21LhCH2eQfRtaJVx9mNOLW0=";
        meta.license = lib.licenses.publicDomain;
      };

      # sha256 because actual output of fpcalc is quite long
      expectedHash = "e2895130bcbe7190184379021daa60c5f5d476da4a2fecb06df7160819662e20";
    in
    ''
      runHook preCheck
      tests/all_tests
      ${lib.optionalString withTools "diff -u <(src/cmd/fpcalc -plain ${exampleAudio} | sha256sum | cut -c-64) <(echo '${expectedHash}')"}
      runHook postCheck
    '';

  meta = {
    changelog = "https://github.com/acoustid/chromaprint/releases/tag/v${finalAttrs.version}";
    homepage = "https://acoustid.org/chromaprint";
    description = "AcoustID audio fingerprinting library";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "libchromaprint" ];
  }
  // lib.attrsets.optionalAttrs withTools {
    mainProgram = "fpcalc";
  };
})
