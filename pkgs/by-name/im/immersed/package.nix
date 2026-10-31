{
  lib,
  appimageTools,
  callPackage,
  fetchurl,
  stdenv,
}:
let
  pname = "immersed";

  sources = {
    x86_64-linux = {
      version = "11.0.0";
      url = "https://web.archive.org/web/20260306043741/https://static.immersed.com/dl/Immersed-x86_64.AppImage";
      hash = "sha256-GbckZ/WK+7/PFQvTfUwwePtufPKVwIwSPh+Bo/cG7ko=";
    };
    aarch64-linux = {
      version = "10.3.2";
      url = "https://web.archive.org/web/20260306043741/https://static.immersed.com/dl/Immersed-aarch64.AppImage";
      hash = "sha256-3BokV30y6QRjE94K7JQ6iIuQw1t+h3BKZY+nEFGTVHI=";
    };
    aarch64-darwin = {
      version = "22.0.0";
      url = "https://web.archive.org/web/20260306043741/https://static.immersed.com/dl/Immersed.dmg";
      hash = "sha256-L5nrkchXD1NIQCknYHVhBWbVJVkkHvKaDjuk9qiY340=";
    };
  };

  source = sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  inherit (source) version;
  src = fetchurl { inherit (source) url hash; };

  meta = {
    description = "VR coworking platform";
    homepage = "https://immersed.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      pandapip1
      crertel
    ];
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
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
    updateScript = ./update.py;
  };
}
