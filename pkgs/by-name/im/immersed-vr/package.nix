{ lib
, appimageTools
, callPackage
, fetchurl
, stdenv
}:
let
  pname = "immersed-vr";
  version = "10.2.1";

  sources = rec {
    x86_64-linux = {
      url = "http://web.archive.org/web/20240415082836/https://static.immersed.com/dl/Immersed-x86_64.AppImage";
      hash = "sha256-hKaF1XzZa0qAh7r1CtK0j2JFqE16hGNBGph7aOnYJCQ=";
    };
    x86_64-darwin = {
      url = "http://web.archive.org/web/20240415083533/https://static.immersed.com/dl/Immersed.dmg";
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
