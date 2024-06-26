{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, alsa-lib
, libjack2
, pkg-config
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fmtoy";
  version = "0-unstable-2024-06-07";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "fmtoy";
    rev = "1339600e2f5a4357f7a50f5c6ad49f3c7635adec";
    hash = "sha256-1kjUPEklZyue/DYn0jSfmXLjF22C+im6klY+S5KCvhc=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'pkg-config' "$PKG_CONFIG"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libjack2
    zlib
  ];

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

  meta = with lib; {
    description = "FM synthesiser based on emulated Yamaha YM chips (OPL, OPM and OPN series)";
    homepage = "https://github.com/vampirefrog/fmtoy";
    license = licenses.gpl3Only;
    mainProgram = "fmtoy_jack";
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
})
