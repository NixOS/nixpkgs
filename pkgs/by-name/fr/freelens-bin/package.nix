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
  version = "1.6.1";

  sources = {
    x86_64-linux = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage";
      hash = "sha256-RiA9OWcs6goRPN8dGsLV3ViBe/ZWB3M7yzTmDHgB3mo=";
    };
    aarch64-linux = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-arm64.AppImage";
      hash = "sha256-hYkI9N8fnEIcj7bPp0lXcB89OZ0kzcd2RrJs3htg6Qo=";
    };
    x86_64-darwin = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-macos-amd64.dmg";
      hash = "sha256-JXqMaw5KlronrpNYNU0YcVwRddHRrK/Y5b5NE3y5BA8=";
    };
    aarch64-darwin = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-macos-arm64.dmg";
      hash = "sha256-0Eg3xBE+yjNvNjloUAJJMpY9h7ifgV+4G3a+EvbXL+Q=";
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
