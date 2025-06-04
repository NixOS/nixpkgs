{
  lib,
  stdenv,
  fetchzip,
  cmake,
  pkg-config,
  boost,
  httplib,
  openssl,
  nlohmann_json,
  curl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "beammp-launcher";
  version = "2.4.0";

  meta = with lib; {
    description = "Official BeamMP Launcher";
    homepage = "https://github.com/BeamMP/BeamMP-Launcher";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ invertedEcho ];
    platforms = platforms.linux;
  };

  src = fetchzip {
    url = "https://github.com/BeamMP/BeamMP-Launcher/archive/refs/tags/v2.4.0.tar.gz";
    sha256 = "sha256-aAQmgK03a3BY4YWuDyTmJzcePchD74SXfbkHwnaOYW8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    boost
    httplib
    openssl
    nlohmann_json
    curl
  ];

  installPhase = ''
    runHoook preInstall
    mkdir -p $out/bin
    cp BeamMP-Launcher $out/bin
    runHook postInstall
  '';
})
