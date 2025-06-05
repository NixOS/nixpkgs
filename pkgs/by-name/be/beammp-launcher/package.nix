{
  lib,
  stdenv,
  fetchFromGitHub,
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

  meta = {
    description = "Official BeamMP Launcher";
    homepage = "https://github.com/BeamMP/BeamMP-Launcher";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [invertedEcho];
    platforms = lib.platforms.linux;
  };

  src = fetchFromGitHub {
    owner = "BeamMP";
    repo = "BeamMP-Launcher";
    rev = "v2.4.0";
    hash = "sha256-aAQmgK03a3BY4YWuDyTmJzcePchD74SXfbkHwnaOYW8=";
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
    runHook preInstall
    install -Dm755 BeamMP-Launcher $out/bin/BeamMP-Launcher
    runHook postInstall
  '';
})
