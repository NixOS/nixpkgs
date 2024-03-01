{ lib
, appimageTools
, fetchurl
}:
appimageTools.wrapType2 rec {
  pname = "immersed-vr";
  version = "9.10";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://web.archive.org/web/20240210075929/https://static.immersed.com/dl/Immersed-x86_64.AppImage";
    hash = "sha256-Mx8UnV4fZSebj9ah650ZqsL/EIJpM6jl8tYmXJZiJpA=";
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
