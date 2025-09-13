{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  fetchpatch2,
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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "acoustid";
    repo = "chromaprint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G3HIMgbjaAXsC+8nt7mkj58xA62qwA8FC+PfTGblhNg=";
  };

  patches = [
    # Fix pkg-config files
    # https://github.com/acoustid/chromaprint/pull/155
    (fetchpatch {
      url = "https://github.com/acoustid/chromaprint/commit/782ef6bb5f6498e35f8e275f76998fbd5ffa36d6.patch";
      hash = "sha256-drUfAMzTrqqB5UbzOnfPq6XD3HI+3sxyJJSTCa0BmD8=";
    })
  ];

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
    (lib.cmakeBool "BUILD_EXAMPLES" withExamples)
    (lib.cmakeBool "BUILD_TOOLS" withTools)
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  doCheck = true;
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
