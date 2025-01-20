{
  lib,
  fetchFromGitHub,
  gitUpdater,
  stdenv,
  testers,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "davs2";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "pkuvcl";
    repo = "davs2";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-SUY3arrVsFecMcbpmQP0+4rtcSRfQc6pzxZDcEuMWPU=";
  };

  postPatch = ''
    substituteInPlace ./version.sh \
      --replace-fail "date" 'date -ud "@$SOURCE_DATE_EPOCH"'
  '';

  preConfigure = ''
    # Generate version.h
    ./version.sh
    cd build/linux

    # When setting this over `env.AS` it gets ignored
    export AS=${lib.getExe buildPackages.nasm}
  '';

  configureFlags =
    [ "--cross-prefix=${stdenv.cc.targetPrefix}" ]
    ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
      (lib.enableFeature true "shared")
      "--system-libdavs2"
    ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  passthru = {
    updateScript = gitUpdater { };
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
  };

  meta = {
    homepage = "https://github.com/pkuvcl/davs2";
    description = "Open-source decoder of AVS2-P2/IEEE1857.4 video coding standard";
    license = lib.licenses.gpl2Plus;
    mainProgram = "davs2";
    pkgConfigModules = [ "davs2" ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.all;
  };
})
