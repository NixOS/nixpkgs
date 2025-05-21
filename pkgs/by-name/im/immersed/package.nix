{
  lib,
  appimageTools,
  callPackage,
  fetchurl,
  stdenv,
}:
let
  pname = "immersed";
  version = "10.6.0";

  sources = rec {
    x86_64-linux = {
      url = "https://web.archive.org/web/20241229041449/https://static.immersed.com/dl/Immersed-x86_64.AppImage";
      hash = "sha256-u07QpGXEXbp7ApZgerq36x+4Wxsz08YAruIVnZeS0ck=";
    };
    aarch64-linux = {
      url = "https://web.archive.org/web/20241229041902/https://static.immersed.com/dl/Immersed-aarch64.AppImage";
      hash = "sha256-3BokV30y6QRjE94K7JQ6iIuQw1t+h3BKZY+nEFGTVHI=";
    };
    x86_64-darwin = {
      url = "https://web.archive.org/web/20241229041652/https://static.immersed.com/dl/Immersed.dmg";
      hash = "sha256-Sgfm0giVR1dDIFIDpNmGmXLXLRgpMXrVxD/oyPc+Lq0=";
    };
    aarch64-darwin = x86_64-darwin;
  };

  src = fetchurl (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}"));

  meta = with lib; {
    description = "VR coworking platform";
    homepage = "https://immersed.com";
    license = licenses.unfree;
    maintainers = with maintainers; [
      haruki7049
      pandapip1
    ];
    platforms = builtins.attrNames sources;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };

in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      src
      meta
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      src
      meta
      ;
  }
