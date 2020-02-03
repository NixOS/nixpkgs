{ appimageTools, fetchurl, gsettings-desktop-schemas, gtk3, lib }:

let
  pname = "station";
  version = "1.52.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/getstation/desktop-app-releases/releases/download/${version}/Station-${version}-x86_64.AppImage";
    sha256 = "0lhiwvnf94is9klvzrqv2wri53gj8nms9lg2678bs4y58pvjxwid";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null;
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/browserx.desktop $out/share/applications/browserx.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/browserx.png \
      $out/share/icons/hicolor/512x512/apps/browserx.png
    substituteInPlace $out/share/applications/browserx.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A single place for all of your web applications";
    homepage = "https://getstation.com";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lattfein ];
  };
}
