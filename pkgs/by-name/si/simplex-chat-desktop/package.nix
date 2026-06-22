{
  lib,
  appimageTools,
  fetchurl,
  stdenv,
}:

let
  pname = "simplex-chat-desktop";
  version = "6.5.5";

  sources = {
    "aarch64-linux" = fetchurl {
      url = "https://github.com/simplex-chat/simplex-chat/releases/download/v${version}/simplex-desktop-aarch64.AppImage";
      hash = "sha256-zBLBSWrADCIafUSynttiT3faJfzDcz8Li/NISWRNTaw=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/simplex-chat/simplex-chat/releases/download/v${version}/simplex-desktop-x86_64.AppImage";
      hash = "sha256-6qb1z4Z/1uuEqLwiVSwuLSlurbHYsj0jVSF00c5LLBA=";
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

  extraPkgs = pkgs: [ pkgs.libnotify ];

  extraBwrapArgs = [
    "--setenv _JAVA_AWT_WM_NONREPARENTING 1"
  ];

  extraInstallCommands = ''
    install --mode=444 -D ${appimageContents}/chat.simplex.app.desktop --target-directory=$out/share/applications
    substituteInPlace $out/share/applications/chat.simplex.app.desktop \
      --replace-fail 'Exec=simplex' 'Exec=simplex-chat-desktop'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  passthru = {
    inherit sources;
    updateScript = ./update.sh;
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
