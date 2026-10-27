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
  version = "1.0.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "librepods-org";
    repo = "librepods";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R84mSviNoDAh5uQhUKBnsOf850E8fCHvDlWKWCBtZF4=";
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
    homepage = "https://github.com/librepods-org/librepods";
    description = "AirPods liberated from Apple's ecosystem";
    license = lib.licenses.gpl3;
    mainProgram = "librepods";
    maintainers = with lib.maintainers; [
      thefossguy
      Cameo007
    ];
  };
})
