{ appimageTools, lib, fetchurl, gtk3, gsettings-desktop-schemas}:

# Based on https://gist.github.com/msteen/96cb7df66a359b827497c5269ccbbf94 and joplin-desktop nixpkgs.
let
  pname = "zettlr";
  version = "1.7.5";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/Zettlr/Zettlr/releases/download/v${version}/Zettlr-${version}-x86_64.appimage";
    sha256 = "040lx01ywdpla34d4abkmh51kchr11s17la6fk6yq77y8zb87xzi";
  };
  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/zettlr.desktop $out/share/applications/zettlr.desktop
    install -m 444 -D ${appimageContents}/zettlr.png $out/share/icons/hicolor/512x512/apps/zettlr.png
    substituteInPlace $out/share/applications/zettlr.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A markdown editor for writing academic texts and taking notes";
    homepage = "https://www.zettlr.com";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3;
    maintainers = with maintainers; [ tfmoraes ];
  };
}
