{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "steam-art-manager";
  version = "3.12.1";
  src = fetchurl {
    url = "https://github.com/Tormak9970/Steam-Art-Manager/releases/download/v${version}/steam-art-manager.AppImage";
    hash = "sha256-eH2Adl0+i+8I7+hPUyCGHzrm7xW34D7MdVex5Yi7pfI=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D "${appimageContents}/usr/share/applications/Steam Art Manager.desktop" $out/share/applications/steam-art-manager.desktop
    install -m 444 -D "${appimageContents}/Steam Art Manager.png" $out/share/icons/hicolor/512x512/apps/steam-art-manager.png
    substituteInPlace $out/share/applications/steam-art-manager.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}' \
      --replace 'Icon=Steam Art Manager' 'Icon=steam-art-manager'
  '';

  meta = {
    description = "A tool to manage and change Steam library artwork";
    homepage = "https://github.com/Tormak9970/Steam-Art-Manager";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ adam-tj ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "steam-art-manager";
  };
}
