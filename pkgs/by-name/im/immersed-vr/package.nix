{ lib
, appimageTools
, fetchurl
}:
appimageTools.wrapType2 rec {
  pname = "immersed-vr";
  version = "9.6";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://web.archive.org/web/20231011083250/https://static.immersed.com/dl/Immersed-x86_64.AppImage";
    hash = "sha256-iA0SQlPktETFXEqCbSoWV9NaWVahkPa6qO4Cfju0aBQ=";
  };

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
  '';

  meta = with lib; {
    description = "A VR coworking platform";
    homepage = "https://immersed.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ haruki7049 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
