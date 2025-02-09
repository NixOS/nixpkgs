{ appimageTools, lib, fetchurl }:

let
  pname = "molotov";
  version = "4.4.0";
  src = fetchurl {
    url = "http://desktop-auto-upgrade.molotov.tv/linux/${version}/molotov.AppImage";
    sha256 = "sha256-l4Il6i8uXSeJqH3ITC8ZUpKXPQb0qcW7SpKx1R46XDc=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D \
      ${appimageContents}/@molotovdesktop-wrapper.desktop \
      $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';
  meta = with lib; {
    description = "French TV service";
    homepage = "https://www.molotov.tv/";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ apeyroux freezeboy ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "molotov";
  };
}
