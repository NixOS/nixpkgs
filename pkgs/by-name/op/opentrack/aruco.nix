{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  opencv4,
  opentrack,
}:

stdenv.mkDerivation {
  pname = "opentrack-aruco";
  version = "0-unstable-2022-03-10";

  src = fetchFromGitHub {
    owner = "opentrack";
    repo = "aruco";
    rev = "e08d336bd2c70859efd19622582817fe8eabe714";
    hash = "sha256-Wf5y//vxRWIZfOxwgZsPPTsUHliA3cbt2FOjouh4/rQ=";
  };

  strictDeps = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ opencv4 ];

  env.NIX_CFLAGS_COMPILE = "-Wall -Wextra -Wpedantic -ffast-math -O3";

  installPhase = ''
    runHook preInstall

    install -Dt $out/include/aruco ./src/include/aruco/*
    install -Dt $out/lib ./src/libaruco.a

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/opentrack/aruco";
    description = "C++ library for detection of AR markers based on OpenCV";
    license = lib.licenses.isc;
    maintainers = opentrack.meta.maintainers;
  };
}
