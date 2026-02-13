{
  lib,
  appimageTools,
  fetchurl,
  gitUpdater,
  stdenv,
}:

let
  pname = "simplex-chat-desktop";
  version = "6.4.10";

  sources = {
    "aarch64-linux" = fetchurl {
      url = "https://github.com/simplex-chat/simplex-chat/releases/download/v${version}/simplex-desktop-aarch64.AppImage";
      hash = "sha256-CvHwYKbieRYbBKUCoKAa11rTy5Opdfb7FKS4poantKs=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/simplex-chat/simplex-chat/releases/download/v${version}/simplex-desktop-x86_64.AppImage";
      hash = "sha256-HueMU1cCOspIsDg4hC9ebMbIvkOtZGiSktB1VSMGgT8=";
    };
  };

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "simplex-chat-desktop: Unsupported system: ${system}";

  src = sources.${system} or throwSystem;

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraBwrapArgs = [
    "--setenv _JAVA_AWT_WM_NONREPARENTING 1"
  ];

  extraInstallCommands = ''
    install --mode=444 -D ${appimageContents}/chat.simplex.app.desktop --target-directory=$out/share/applications
    substituteInPlace $out/share/applications/chat.simplex.app.desktop \
      --replace-fail 'Exec=simplex' 'Exec=simplex-chat-desktop'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/simplex-chat/simplex-chat";
    rev-prefix = "v";
    # skip tags that does not correspond to official releases, like vX.Y.Z-(beta,fdroid,armv7a).
    ignoredVersions = "-";
  };

  meta = {
    description = "Desktop application for SimpleX Chat";
    mainProgram = "simplex-chat-desktop";
    homepage = "https://simplex.chat";
    changelog = "https://github.com/simplex-chat/simplex-chat/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ terryg ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
