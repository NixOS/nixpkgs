{ lib, fetchurl, appimageTools, }:

let
  pname = "youtube-music";
  version = "1.18.0";

  src = fetchurl {
    url = "https://github.com/th-ch/youtube-music/releases/download/v${version}/YouTube-Music-${version}.AppImage";
    sha256 = "sha256-7U+zyLyXMVVMtRAT5yTEUqS3/qP5Kx/Yuu263VcsbAE=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;
  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
    ++ [ pkgs.libappindicator ];

  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},${pname}}
    install -m 444 \
        -D ${appimageContents}/youtube-music.desktop \
        -t $out/share/applications
    substituteInPlace \
        $out/share/applications/youtube-music.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Electron wrapper around YouTube Music";
    homepage = "https://th-ch.github.io/youtube-music/";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    maintainers = [ maintainers.aacebedo ];
  };
}
