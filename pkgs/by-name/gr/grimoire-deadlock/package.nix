{
  lib,
  appimageTools,
  makeDesktopItem,
  fetchurl,
}:
let
  pname = "grimoire";
  version = "1.28.1";
  src = fetchurl {
    url = "https://github.com/Slush97/grimoire/releases/download/v${version}/Grimoire-${version}.AppImage";
    hash = "sha256-q+QnLo1aaZ3bWSbEjGC+yITh4IthgyUeAJ0tcurbWhk=";
  };
  desktopItem = makeDesktopItem {
    name = "grimoire";
    desktopName = "Grimoire";
    comment = "Mod manager for Deadlock";
    exec = "grimoire";
    icon = "grimoire";
    terminal = false;
    keywords = [
      "Deadlock"
      "Mods"
      "Modding"
      "Mod Manager"
      "Game"
      "Valve"
    ];
    startupWMClass = "grimoire";
  };
  contents = appimageTools.extract { inherit src pname version; };
in
(appimageTools.wrapType2 {
  inherit pname version src;

  executableName = "grimoire";

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${desktopItem}/share/applications $out/share/applications
    ln -s ${contents}/usr/share/icons $out/share/icons
  '';

  meta = with lib; {
    description = "Mod manager for Deadlock";
    homepage = "https://github.com/Slush97/grimoire";
    license = licenses.mit;
    mainProgram = "grimoire";
    maintainers = with maintainers; [ justdeeevin ];
    platforms = platforms.linux;
  };
}).overrideAttrs
  (old: {
    __structuredAttrs = true;
    strictDeps = true;
  })
