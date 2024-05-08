{ lib
, appimageTools
, fetchurl
}:

appimageTools.wrapType2 rec {
  pname = "parsify";
  version = "2.0.1";

  src = fetchurl {
    url = "https://github.com/parsify-dev/desktop/releases/download/v${version}/Parsify-${version}-linux-x86_64.AppImage";
    hash = "sha256-ltWqRW+cBvuUJzhya62WsBY5zqIua9xhilxfd9gr24A=";
  };

  extraInstallCommands =
  let contents = appimageTools.extract { inherit pname version src; };
  in ''
    install -m 444 -D ${contents}/@parsifydesktop.desktop -t $out/share/applications

    substituteInPlace $out/share/applications/@parsifydesktop.desktop \
      --replace "Exec=AppRun" "Exec=${pname}"

    cp -r ${contents}/usr/share/* $out/share
  '';

  meta = with lib; {
    description = "Next generation notepad-based calculator, built with extendibility and privacy in mind";
    homepage = "https://parsify.app/";
    license = licenses.unfree;
    maintainers = with maintainers; [ kashw2 ];
    platforms = platforms.linux;
    mainProgram = "parsify";
  };
}
