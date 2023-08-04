{ lib, fetchurl, appimageTools, }:

let
  pname = "ytmdesktop";
  version = "1.13.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/ytmdesktop/ytmdesktop/releases/download/v${version}/YouTube-Music-Desktop-App-${version}.AppImage";
    sha256 = "0f5l7hra3m3q9zd0ngc9dj4mh1lk0rgicvh9idpd27wr808vy28v";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}

    install -m 444 \
        -D ${appimageContents}/youtube-music-desktop-app.desktop \
        -t $out/share/applications
    substituteInPlace \
        $out/share/applications/youtube-music-desktop-app.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "A Desktop App for YouTube Music";
    homepage = "https://ytmdesktop.app/";
    license = licenses.cc0;
    platforms = platforms.linux;
    maintainers = [ maintainers.lgcl ];
    mainProgram = "ytmdesktop";
  };
}
