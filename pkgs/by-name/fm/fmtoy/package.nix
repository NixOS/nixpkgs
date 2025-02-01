{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  alsa-lib,
  cmake,
  libjack2,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fmtoy";
  version = "0-unstable-2024-12-15";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "fmtoy";
    rev = "6858fc8ad3171df2c9b90cb1e62719af9fc4f7c2";
    fetchSubmodules = true;
    hash = "sha256-OiPKtFPlTxdMNSTLJXcXZkqjzUiGQKXSF2udHePBpho=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'pkg-config' "$PKG_CONFIG"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libjack2
    zlib
  ];

  dontUseCmakeConfigure = true;

  enableParallelBuilding = true;

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 fmtoy_jack $out/bin/fmtoy_jack

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "FM synthesiser based on emulated Yamaha YM chips (OPL, OPM and OPN series)";
    homepage = "https://github.com/vampirefrog/fmtoy";
    license = lib.licenses.gpl3Only;
    mainProgram = "fmtoy_jack";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.linux;
  };
})
