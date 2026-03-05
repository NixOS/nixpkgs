{
  stdenv,
  stdenvNoCC,
  fetchurl,
  lib,
  appimageTools,
  makeWrapper,
  _7zz,
  darwin,
  writeShellScript,
  nix-update,
  jq,
  common-updater-scripts,
}:

let

  pname = "freelens-bin";
  version = "1.8.1";

  sources = {
    x86_64-linux = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage";
      hash = "sha256-Goe/eAmefL+4itHrGmQjBGVWalk559kGg/OgA1yKKdk=";
    };
    aarch64-linux = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-arm64.AppImage";
      hash = "sha256-Mcvjiv7tQU56uaVvtoK5mn6jpQsRnP1F2UeG8OHhywQ=";
    };
    x86_64-darwin = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-macos-amd64.dmg";
      hash = "sha256-4b4xzr4shEBYhqQ+NZaew4ZSq3J5den5KPJ7X8UpTJ8=";
    };
    aarch64-darwin = {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-macos-arm64.dmg";
      hash = "sha256-jCR/ypqGTp8swi1b9hgm4iWjGoKA2pW0mqxF8QJzYVk=";
    };
  };

  src = fetchurl {
    inherit (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}")) url hash;
  };

  passthru = {
    updateScript = writeShellScript "update-freelens-bin" ''
      ${lib.getExe nix-update} freelens-bin --override-filename pkgs/by-name/fr/freelens-bin/package.nix
      latestVersion=$(nix eval --log-format raw --raw --file default.nix freelens-bin.version)
      if [[ "$latestVersion" == "$UPDATE_NIX_OLD_VERSION" ]]; then
        exit 0
      fi
      systems=$(nix eval --json -f . freelens-bin.meta.platforms | ${lib.getExe jq} --raw-output '.[]')
      for system in $systems; do
        hash=$(nix store prefetch-file --json $(nix eval --raw -f . freelens-bin.src.url --system "$system") | ${lib.getExe jq} --raw-output .hash)
        ${lib.getExe' common-updater-scripts "update-source-version"} freelens-bin $latestVersion $hash --system=$system --ignore-same-version --ignore-same-hash
      done
    '';
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    inherit src;
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
      passthru
      meta
      _7zz
      ;
    autoSignDarwinBinariesHook = darwin.autoSignDarwinBinariesHook;
  }
else
  import ./linux.nix {
    inherit
      pname
      version
      src
      passthru
      meta
      appimageTools
      makeWrapper
      ;
  }
