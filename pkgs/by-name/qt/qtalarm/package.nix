{
  stdenv,
  lib,
  fetchFromGitHub,
  kdePackages,
  qt6,
  makeDesktopItem,
  nix-update-script,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtalarm";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "CountMurphy";
    repo = "QTalarm";
    tag = finalAttrs.version;
    hash = "sha256-IN/XdR8J5uMIAjb1G2kzuLDtO972RLKSy3Ceh9CcHWw=";
  };

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtmultimedia
  ];

  installPhase = ''
    runHook preInstall
  ''
  + (
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        mv qtalarm.app $out/Applications
      ''
    else
      ''
        install -Dm755 qtalarm -t $out/bin
        install -Dm644 Icons/1349069370_Alarm_Clock.png $out/share/icons/hicolor/48x48/apps/qtalarm.png
        install -Dm644 Icons/1349069370_Alarm_Clock24.png $out/share/icons/hicolor/24x24/apps/qtalarm.png
        install -Dm644 Icons/1349069370_Alarm_Clock16.png $out/share/icons/hicolor/16x16/apps/qtalarm.png
      ''
  )
  + ''
    runHook postInstall
  '';

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    qt6.qmake
    copyDesktopItems
  ];

  passthru.updateScript = nix-update-script { };

  desktopItems = [
    (makeDesktopItem {
      name = "QTalarm";
      exec = "qtalarm";
      icon = "qtalarm";
      desktopName = "QTalarm";
      genericName = "Nifty alarm clock";
      categories = [
        "Application"
        "Utility"
      ];
      terminal = false;
    })
  ];
  meta = {
    description = "Nifty alarm clock written in QT";
    changelog = "https://github.com/CountMurphy/QTalarm/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/CountMurphy/QTalarm";
    license = lib.licenses.gpl3Only;
    mainProgram = "qtalarm";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.unix;
  };
})
