{
  lib,
  stdenvNoCC,
  fetchurl,
  callPackage,
}:

let
  pname = "postman";
  version = "11.56.4";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenvNoCC.hostPlatform.system}
          or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
      system = selectSystem {
        aarch64-darwin = "osx_arm64";
        aarch64-linux = "linuxarm64";
        x86_64-darwin = "osx_64";
        x86_64-linux = "linux64";
      };
    in
    fetchurl {
      name = "postman-${version}.${if stdenvNoCC.hostPlatform.isLinux then "tar.gz" else "zip"}";
      url = "https://dl.pstmn.io/download/version/${version}/${system}";
      hash = selectSystem {
        aarch64-darwin = "sha256-DNhTzTul3SZSsqc3g1oOSSl1sGQ3t6FD5bbL4dMHzEk=";
        aarch64-linux = "sha256-8CaqyMuZEcdgKfE2OxHCEAVsTFBtFDOfdHfTWASJAU4=";
        x86_64-darwin = "sha256-cRHyqNBW/1l2VsK89ue2K+X/Uszpzu9wXg4O91Adfy4=";
        x86_64-linux = "sha256-bwvNmcSBbwLt3kNbd05Yy2IgNHUJx7qTvDMKrGmOOi0=";
      };
    };

  meta = {
    changelog = "https://www.postman.com/release-notes/postman-app/#${
      lib.replaceStrings [ "." ] [ "-" ] version
    }";
    description = "API Development Environment";
    homepage = "https://www.getpostman.com";
    license = lib.licenses.postman;
    maintainers = with lib.maintainers; [
      Crafter
      evanjs
      johnrichardrinehart
      tricktron
    ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in

if stdenvNoCC.hostPlatform.isDarwin then
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
