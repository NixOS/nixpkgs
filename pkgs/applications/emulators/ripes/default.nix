{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, qtbase
, qtsvg
, qtcharts
, wrapQtAppsHook
, cmake
, python3
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "ripes";
  # Pulling unstable version as latest stable does not build against gcc-13.
  version = "2.2.6-unstable-2024-01-02";

  src = fetchFromGitHub {
    owner = "mortbopet";
    repo = "Ripes";
    rev = "0faf41b669a93a1944707cd7d111a5e9241425fe";
    fetchSubmodules = true;
    hash = "sha256-3+jibS1mGYBy9jmucytc7GvB1ZKRfh7aXtDty77hA3k=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtsvg
    qtcharts
  ];

  installPhase = ''
    runHook preInstall
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -r Ripes.app $out/Applications/
    makeBinaryWrapper $out/Applications/Ripes.app/Contents/MacOS/Ripes $out/bin/Ripes
  '' + lib.optionalString stdenv.isLinux ''
    install -D Ripes $out/bin/Ripes
  '' + ''
    cp -r ${src}/appdir/usr/share $out/share
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A graphical processor simulator and assembly editor for the RISC-V ISA";
    homepage = "https://github.com/mortbopet/Ripes";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "Ripes";
    maintainers = with maintainers; [ rewine ];
  };
}
