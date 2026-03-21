{
  stdenv,
  fetchFromGitHub,
  libpulseaudio,
  openssl,
  qt6,
  cmake,
  pkg-config,
  lib,
}:

stdenv.mkDerivation {
  pname = "librepods";
  version = "0.1.0-unstable-2025-12-07";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    rev = "0e1f784737122913c21b429810d059aadfb4479e";
    hash = "sha256-nXEMIyQWEDMjyKGPAleqqSttznNmrdSHKT4Kr2tLHBY=";
  };

  sourceRoot = "source/linux";

  buildInputs = [
    libpulseaudio
    openssl
    qt6.qtbase
    qt6.qtconnectivity
    qt6.qtquick3d
    qt6.qttools
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  meta = {
    homepage = "https://github.com/kavishdevar/librepods";
    description = "AirPods liberated from Apple's ecosystem";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.thefossguy ];
  };
}
