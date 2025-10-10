{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
    # fix generated pkg-config files
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
  ]
  ++ lib.optionals (!finalAttrs.finalPackage.doCheck) [
    # special-cased to avoid a mass-rebuild: remove from `lib.optionals` as part of next update
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
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
      expectedHash = "c47ae40e02caf798ff5ab4d91ff00cfdca8f6786c581662436941d3e000c9aac";
    in
    ''
      runHook preCheck
      tests/all_tests
      ${lib.optionalString withTools "diff -u <(src/cmd/fpcalc ${exampleAudio} | sha256sum | cut -c-64) <(echo '${expectedHash}')"}
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
