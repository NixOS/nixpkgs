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

stdenv.mkDerivation (finalAttrs: {
  pname = "librepods";
  version = "0.2.0-alpha.2";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    tag = "v${finalAttrs.version}";
    hash = "sha256-37dLiXC+eO4f5waLKgMMpHXH1m6W54O/l2axJsnyU5M=";
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
    mainProgram = "librepods";
    maintainers = with lib.maintainers; [
      thefossguy
      Cameo007
    ];
  };
})
