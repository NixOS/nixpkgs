{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  openssl,
  libpulseaudio,
  pkg-config,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "librepods";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    rev = "linux-v${finalAttrs.version}";
    hash = "sha256-HHF14I6mpCHsRcSzQmrZhGeCGr+1oNCK4esOjVu4M+E=";
  };

  sourceRoot = "${finalAttrs.src.name}/linux";

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtconnectivity
    qt6.qtmultimedia
    qt6.qtdeclarative
    openssl
    libpulseaudio
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=linux-v([\\d\\.]+)" ];
  };

  meta = {
    description = "Open-source AirPods integration for Linux";
    homepage = "https://github.com/kavishdevar/librepods";
    changelog = "https://github.com/kavishdevar/librepods/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ shgew ];
    platforms = lib.platforms.linux;
    mainProgram = "librepods";
  };
})
