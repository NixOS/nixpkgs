{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qiec104";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "MicroKoder";
    repo = "QIEC104";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/kIAWxeJATKSEqXfRA3/6+TbHVeaIWZqsMYumvj2OuU=";
  };

  nativeBuildInputs = [
    qt5.qmake
    qt5.wrapQtAppsHook
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux copyDesktopItems;

  desktopItems = [
    (makeDesktopItem {
      name = "qiec104";
      desktopName = "Q104";
      comment = finalAttrs.meta.description;
      exec = finalAttrs.meta.mainProgram;
      icon = "Q104";
      terminal = false;
      categories = [ "Utility" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm755 Q104 -t $out/bin
      install -Dm644 icons/Q104.png -t $out/share/icons/hicolor/128x128/apps
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/{Applications,bin}
      mv Q104.app $out/Applications
      ln -s $out/Applications/Q104.app/Contents/MacOS/Q104 $out/bin/Q104
    ''}

    runHook postInstall
  '';

  meta = {
    description = "Small IEC104 client";
    homepage = "https://github.com/MicroKoder/QIEC104";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
    mainProgram = "Q104";
  };
})
