{ stdenv, appimageTools, fetchurl, gsettings-desktop-schemas, gtk3 }:

let
  version = "0.7.1";
  pname = "devdocs-desktop";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/egoist/devdocs-desktop/releases/download/v${version}/DevDocs-${version}.AppImage";
    sha256 = "5bba99a34c90a65eff67aface0b7446cbf43d620a1c195f27e7bb33ab6d3d0c2";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/devdocs.desktop $out/share/applications/devdocs.desktop
    install -m 444 -D ${appimageContents}/devdocs.png $out/share/icons/hicolor/0x0/apps/devdocs.png
    substituteInPlace $out/share/applications/devdocs.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with stdenv.lib; {
    description = "A full-featured desktop app for DevDocs.io";
    longDescription = ''
      DevDocs.io combines multiple API documentations in a fast, organized, and searchable interface. This is an unofficial desktop app for it.
    '';
    homepage = "https://github.com/egoist/devdocs-desktop";
    downloadPage = "https://github.com/egoist/devdocs-desktop/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ ymarkus ];
    platforms = [ "x86_64-linux" ];
  };
}
