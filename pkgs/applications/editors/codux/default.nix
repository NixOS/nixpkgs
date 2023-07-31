{ lib
, appimageTools
, fetchurl
}:

let
  pname = "codux";
  version = "15.6.1";

  src = fetchurl {
    url = "https://github.com/wixplosives/codux-versions/releases/download/${version}/Codux-${version}.x86_64.AppImage";
    sha256 = "sha256-a8zv5pVtS80J2PTrUiW8AA3rJ+rPAAzaaT5DVBLK5JE=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in

appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
    substituteInPlace $out/share/applications/${pname}.desktop  --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A visual IDE for React";
    homepage = "https://www.codux.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ dit7ya ];
  };
}
