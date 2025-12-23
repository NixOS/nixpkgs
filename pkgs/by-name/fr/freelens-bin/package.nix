{
  stdenv,
  stdenvNoCC,
  fetchurl,
  lib,
  appimageTools,
  makeWrapper,
  undmg,
}:

let

  pname = "freelens-bin";
  version = "1.7.0";

  sources = {
    x86_64-linux = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage";
      hash = "sha256-VeWTfJf66Cq4ZyR/mO0kzm8wD+Auo1MZvXPYC1Bbf7U=";
    };
    aarch64-linux = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-arm64.AppImage";
      hash = "sha256-KzX9GEaAVRWUYjaj31PVc4OQvFScXsZqZMR+baPADZA=";
    };
    x86_64-darwin = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-macos-amd64.dmg";
      hash = "sha256-qtfOf14gmH4HAA/UZ86QR1sA75lzXVaoWNb0N+mJWPw=";
    };
    aarch64-darwin = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-macos-arm64.dmg";
      hash = "sha256-U6Oj+ip/srVzfyE04rJSZgaAtIt7y0X8nLgHeIvB/So=";
    };
  };

  src = fetchurl {
    inherit (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}")) url hash;
  };

  meta = {
    description = "Free IDE for Kubernetes";
    longDescription = ''
      Freelens is a free and open-source user interface designed for managing Kubernetes clusters. It provides a standalone application compatible with macOS, Windows, and Linux operating systems, making it accessible to a wide range of users. The application aims to simplify the complexities of Kubernetes management by offering an intuitive and user-friendly interface.
    '';
    homepage = "https://github.com/freelensapp/freelens/";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ skwig ];
    platforms = builtins.attrNames sources;
    mainProgram = "freelens";
  };

in
if stdenv.hostPlatform.isDarwin then
  import ./darwin.nix {
    inherit
      stdenvNoCC
      pname
      version
      src
      meta
      undmg
      ;
  }
else
  import ./linux.nix {
    inherit
      pname
      version
      src
      meta
      appimageTools
      makeWrapper
      ;
  }
