{ lib
, appimageTools
, callPackage
, fetchurl
, stdenv
}:
let
  pname = "immersed-vr";
  version = "10.1.1";

  sources = rec {
    x86_64-linux = {
      url = "https://web.archive.org/web/20240325135651/https://static.immersed.com/dl/Immersed-x86_64.AppImage";
      hash = "sha256-NwO8nJqwLnr4wi+MSoXaJwsPi8zSlFQ8hNsIscdEcw8=";
    };
    x86_64-darwin = {
      url = "https://web.archive.org/web/20231227045127/https://static.immersed.com/dl/Immersed.dmg";
      hash = "sha256-CR2KylovlS7zerZIEScnadm4+ENNhib5QnS6z5Ihv1Y=";
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
