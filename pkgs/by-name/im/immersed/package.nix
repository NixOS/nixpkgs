{
  lib,
  appimageTools,
  callPackage,
  fetchurl,
  stdenv,
}:
let
  pname = "immersed";
  version = "10.9.0";

  sources = lib.mapAttrs (_: fetchurl) rec {
    x86_64-linux = {
      url = "https://web.archive.org/web/20250725134919if_/https://static.immersed.com/dl/Immersed-x86_64.AppImage";
      hash = "sha256-plGcvZRpV+nhQ4FoYiIuLmyOg/SHJ8ZjT4Fh6UyH9W0=";
    };
    aarch64-linux = {
      url = "https://web.archive.org/web/20250725135029if_/https://static.immersed.com/dl/Immersed-aarch64.AppImage";
      hash = "sha256-3BokV30y6QRjE94K7JQ6iIuQw1t+h3BKZY+nEFGTVHI=";
    };
    x86_64-darwin = {
      url = "https://web.archive.org/web/20250725135025if_/https://static.immersed.com/dl/Immersed.dmg";
      hash = "sha256-lmSkatB75Bztm19aCC50qrd/NV+HQX9nBMOTxIguaqI=";
    };
    aarch64-darwin = x86_64-darwin;
  };

  src = sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = with lib; {
    description = "VR coworking platform";
    homepage = "https://immersed.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ pandapip1 ];
    platforms = builtins.attrNames sources;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };

in

(
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
)
// {
  passthru = {
    inherit sources;
  };
}
