{
  fetchurl,
  appimageTools,
  makeDesktopItem,

  xdg-user-dirs,
  mpv-unwrapped,
  libepoxy,
  stdenv,
  lib,
}:
let
  pname = "fladder";
  version = "0.7.5";
  src = fetchurl {
    url = "https://github.com/DonutWare/Fladder/releases/download/v${version}/Fladder-Linux-${version}.AppImage";
    hash = "sha256:6955e7634d29c588991ed19f24c837e3cb6a51be80a7e0ca152f443c4f92add3";
  };
  appImageContent = appimageTools.extract { inherit pname version src; };
  desktopItem = makeDesktopItem {
    name = "nl.jknaapen.fladder";
    desktopName = "Fladder";
    genericName = "Video Player";
    exec = "fladder";
    icon = "fladder";
    startupWMClass = "fladder";
    comment = "A Simple Jellyfin frontend built on top of Flutter";
    categories = [
      "AudioVideo"
      "Video"
      "Player"
    ];
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs = pkgs: [
    xdg-user-dirs
    mpv-unwrapped
    libepoxy
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications/
    install -Dm444 ${appImageContent}/fladder_icon_desktop.png \
      $out/share/icons/hicolor/scalable/apps/fladder.png
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
  '';

  meta = {
    # Fladder depends on `ìsar`, which for Linux is only compiled for x86_64. https://github.com/jmshrv/finamp/issues/766
    # stolen from finamp
    broken = stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isx86_64;
    description = "A Simple Jellyfin frontend built on top of Flutter";
    homepage = "https://github.com/DonutWare/Fladder";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ serhao ];
    mainProgram = "fladder";
    platforms = lib.platforms.linux;
  };
}
