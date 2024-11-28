{
  lib,
  appimageTools,
  callPackage,
  fetchurl,
  stdenv,
}:
let
  pname = "immersed";
  version = "10.5.0";

  sources = rec {
    x86_64-linux = {
      url = "https://web.archive.org/web/20240909144905if_/https://static.immersed.com/dl/Immersed-x86_64.AppImage";
      hash = "sha256-/fc/URYJZftZPyVicmZjyvcGPLaHrnlsrERlQFN5E98=";
    };
    x86_64-darwin = {
      url = "https://web.archive.org/web/20240910022037if_/https://static.immersed.com/dl/Immersed.dmg";
      hash = "sha256-UkfB151bX0D5k0IBZczh36TWOOYJbBe5e6LIErON214=";
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
