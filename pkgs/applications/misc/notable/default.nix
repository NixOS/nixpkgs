{ appimageTools, fetchurl, lib }:

let
  pname = "notable";
  version = "1.8.4";
  sha256 = "0rvz8zwsi62kiq89pv8n2wh9h5yb030kvdr1vf65xwqkhqcrzrby";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/notable/notable/releases/download/v${version}/Notable-${version}.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

in
appimageTools.wrapType2 rec {

  inherit name src;

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [ p.at-spi2-atk p.at-spi2-core ];
  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/notable.desktop $out/share/applications/notable.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/notable.png \
      $out/share/icons/hicolor/1024x1024/apps/notable.png
    substituteInPlace $out/share/applications/notable.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "The markdown-based note-taking app that doesn't suck";
    homepage = "https://github.com/notable/notable";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ dtzWill ];
  };
}
