{
  lib,
  stdenv,
  docutils,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxmp";
  version = "4.7.4";

  src = fetchFromGitHub {
    owner = "libxmp";
    repo = "libxmp";
    tag = "libxmp-${finalAttrs.version}";
    hash = "sha256-wkqOb79jKu72buZIc6vEIN8XHnJuejcnsgXTqMnNTjg=";
  };

  patches = [
    # https://github.com/libxmp/libxmp/pull/1039
    (fetchpatch {
      name = "0001-libxmp-IT-Fix-ChibiTracker-OpenMPT-detection-on-big-endian.patch";
      url = "https://github.com/libxmp/libxmp/commit/5c63c2f7809dc6f17342df738a3dde5ca65221c9.patch";
      hash = "sha256-AesBZlZP7Pcu1MWoVAEZCCcDEy5o/6Zn1D7NyTUjbeE=";
    })
  ];

  postPatch = lib.optionalString finalAttrs.finalPackage.doCheck (
    lib.strings.concatMapStringsSep "\n" (test: ''
      echo "Disabling test: ${test}"
      sed -i test-dev/all_tests.txt -e '/${test}/d'
    '') finalAttrs.disabledTests
  );

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    docutils
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_STATIC" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "WITH_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  disabledTests = lib.optionals stdenv.hostPlatform.isBigEndian [
    # Test failures on ppc64, dug into them abit & created upstream issues:
    # https://github.com/libxmp/libxmp/issues/1036
    "test_loader_med4_decvol"

    # https://github.com/libxmp/libxmp/issues/1037
    "test_loader_titanics"

    # https://github.com/libxmp/libxmp/issues/1038
    "test_api_smix_load_sample"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "libxmp-(.*)"
    ];
  };

  meta = {
    description = "Extended module player library";
    homepage = "https://xmp.sourceforge.net/";
    changelog = "https://github.com/libxmp/libxmp/releases/tag/${finalAttrs.src.tag}";
    longDescription = ''
      Libxmp is a library that renders module files to PCM data. It supports
      over 90 mainstream and obscure module formats including Protracker (MOD),
      Scream Tracker 3 (S3M), Fast Tracker II (XM), and Impulse Tracker (IT).
    '';
    maintainers = with lib.maintainers; [ marcin-serwin ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
