{ lib
, appimageTools
, callPackage
, fetchurl
, stdenv
}:
let
  pname = "immersed-vr";
  version = "10.2.0";

  sources = rec {
    x86_64-linux = {
      url = "https://web.archive.org/web/20240411143649/https://static.immersed.com/dl/Immersed-x86_64.AppImage";
      hash = "sha256-ZY9pwOryADkpbMLx1w5Lymx6iQ0BhIrFAAvy47wLnQ8=";
    };
    x86_64-darwin = {
      url = "https://web.archive.org/web/20240411144415/https://static.immersed.com/dl/Immersed.dmg";
      hash = "sha256-MdRJAo85xAB8OEgdQf0BjfORwSLIwtpOVwJ5qWfpXJY=";
    };
    aarch64-darwin = x86_64-darwin;
  };

  src = fetchurl (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}"));

  meta = with lib; {
    description = "A VR coworking platform";
    homepage = "https://immersed.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ haruki7049 ];
    platforms = builtins.attrNames sources;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };

in if stdenv.isDarwin
then callPackage ./darwin.nix { inherit pname version src meta; }
else callPackage ./linux.nix { inherit pname version src meta; }
