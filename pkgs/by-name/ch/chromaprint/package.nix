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
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "acoustid";
    repo = "chromaprint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bFplHaqXYvGbl8E8b/HUNFO4X+B/HPZjGTmuVFPjS3g=";
  };

  patches = [
    # Use FFmpeg 5.x
    # https://github.com/acoustid/chromaprint/pull/120
    (fetchpatch {
      url = "https://github.com/acoustid/chromaprint/commit/8ccad6937177b1b92e40ab8f4447ea27bac009a7.patch";
      hash = "sha256-yO2iWmU9s2p0uJfwIdmk3jZ5HXBIQZ/NyOqG+Y5EHdg=";
      excludes = [ "package/build.sh" ];
    })
    # ffmpeg5 fix for issue #122
    # https://github.com/acoustid/chromaprint/pull/125
    (fetchpatch {
      url = "https://github.com/acoustid/chromaprint/commit/aa67c95b9e486884a6d3ee8b0c91207d8c2b0551.patch";
      hash = "sha256-dLY8FBzBqJehAofE924ayZK0HA/aKiuFhEFxL7dg6rY=";
    })
    # Fix for FFmpeg 7
    (fetchpatch2 {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/chromaprint/-/raw/74ae4c7faea2114f2d70a57755f714e348476d28/ffmpeg-7.patch";
      hash = "sha256-io+dzhDNlz+2hWhNfsyePKLQjiUvSzbv10lHVKumTEk=";
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
