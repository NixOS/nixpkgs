{
  stdenv,
  lib,
  fetchFromGitHub,
  libsForQt5,
  makeDesktopItem,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "coil64";
  version = "2.3.37";

  src = fetchFromGitHub {
    owner = "radioacoustick";
    repo = "Coil64";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7wV3wpNKNGXlWKOE/610npNGkrMlQYbwVXkacAivAE4=";
  };

  buildInputs = [
    libsForQt5.qt5.qtbase
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 Coil64 -t $out/bin
    runHook postInstall
  '';

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    libsForQt5.qmake
  ];

  passthru.updateScript = nix-update-script {};

  desktopItems = [
    (makeDesktopItem {
      name = "Coil64";
      exec = "Coil64";
      desktopName = "Coil64";
      genericName = "Coil inductance calculator";
      categories = [
        "Application"
        "Utility"
      ];
      terminal = false;
    })
  ];
  meta = {
    description = "Freeware coil inductance calculator for radio frequency coils";
    mainProgram = "Coil64";
    homepage = "https://coil32.net/";
    maintainers = with lib.maintainers; [
      spiwocoal
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };
})
