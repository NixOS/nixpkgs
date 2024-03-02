{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, alsa-lib
, libfmvoice
, libjack2
, pkg-config
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fmtoy";
  version = "0.0.0-unstable-2023-05-21";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "fmtoy";
    rev = "2b54180d8edd0de90e2af01bf9ff303bc916e893";
    hash = "sha256-qoMw4P+QEw4Q/wKBvFPh+WxkmOW6qH9FuFFkO2ZRrMc=";
  };

  postPatch = ''
    rmdir libfmvoice
    cp --no-preserve=all -r ${libfmvoice.src} libfmvoice

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
