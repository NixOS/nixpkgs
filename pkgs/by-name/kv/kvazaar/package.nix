{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  testers,
  cmake,
  libtool,
  ffmpeg-headless,
  hm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kvazaar";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "ultravideo";
    repo = "kvazaar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Th30XO3m4GVeDvdb/RIwKT6+To9C/YU7y8s8hm7vPi0=";
  };

  postPatch = ''
    substituteInPlace tests/util.sh --replace-fail '../libtool' '${lib.getExe libtool}'
    substituteInPlace tests/util.sh --replace-fail 'TAppDecoderStatic' '${lib.getExe' hm "TAppDecoder"}'

    chmod +x tests/util.sh
  '';

  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [
    ffmpeg-headless
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  env.XFAIL_TESTS = lib.optionalString stdenv.hostPlatform.isDarwin "test_slices.sh";

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Open-source HEVC encoder";
    homepage = "https://github.com/ultravideo/kvazaar";
    changelog = "https://github.com/ultravideo/kvazaar/releases/tag/v${finalAttrs.version}";
    pkgConfigModules = [ "kvazaar" ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
