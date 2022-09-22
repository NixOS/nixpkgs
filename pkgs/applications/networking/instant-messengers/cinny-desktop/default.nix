{ lib
, stdenvNoCC
, callPackage
, fetchurl
}:

let
  version = "2.1.3";

  mkPackage = path: src: callPackage path {
    pname = "cinny-desktop";
    inherit version src;

    meta = with lib; {
      description = "Yet another matrix client for desktop";
      homepage = "https://github.com/cinnyapp/cinny-desktop";
      mainProgram = "cinny";
      license = licenses.mit;
      platforms = lib.attrNames systems;
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      maintainers = with maintainers; [
        aveltras
        ivar
      ];
    };
  };

  systems = {
    x86_64-linux = mkPackage ./linux.nix (fetchurl {
      url = "https://github.com/cinnyapp/cinny-desktop/releases/download/v${version}/Cinny_desktop-x86_64.deb";
      sha256 = "sha256-fUnWGnulj/515aEdd+rCy/LGLLAs2yAOOBUn9K1LhNs=";
    });

    x86_64-darwin = mkPackage ./darwin.nix (fetchurl {
      url = "https://github.com/cinnyapp/cinny-desktop/releases/download/v${version}/Cinny_desktop-x86_64.dmg";
      sha256 = "sha256-f9JQn5BKHluXLi89aUHuRde757Kk211w4s61tRmkNew=";
    });
  };
in
systems.${stdenvNoCC.hostPlatform.system} or (throw "unsupported platform ${stdenvNoCC.hostPlatform.system}")
