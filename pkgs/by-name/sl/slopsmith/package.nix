{
  appimageTools,
  fetchurl,
  makeDesktopItem,
  lib,
  libxshmfence,
  wayland,
  wayland-protocols,
}:
let
  pname = "slopsmith";
  version = "0.2.8";
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/byrongamatos/slopsmith-desktop/releases/download/v${version}/Slopsmith-${version}.AppImage";
    hash = "sha256-VYO/lUEBbunAom4S3JxqwDrIY2E8hllBL3Qdfgv0OF8=";
  };

  desktopItem = makeDesktopItem {
    name = "Slopsmith";
    comment = "Browse, play and practice CDLC from CustomsForge";
    desktopName = "Slopsmith";
    noDisplay = false;
    exec = "slopsmith";
    terminal = false;
    mimeTypes = [ ];
    categories = [
      "Game"
      "Education"
      "Audio"
    ];
    keywords = [
      "guitar"
      "music"
      "vst"
    ];
  };

in
appimageTools.wrapType2 {
  inherit pname version src;
  strictDeps = true;
  __structuredAttrs = true;

  extraArgs = {
    strictDeps = true;
  };

  extraInstallCommands = ''
    install -Dm444 -t $out/share/applications ${desktopItem}/share/applications/*
  '';

  extraPkgs = _: [
    libxshmfence
    wayland
    wayland-protocols
  ];

  meta = with lib; {
    description = "Browse, play and practice CDLC from CustomsForge";
    homepage = "https://github.com/byrongamatos/slopsmith";
    license = lib.licenses.agpl3Only;
    maintainers = with maintainers; [ tarinaky ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "slopsmith";
  };
}
