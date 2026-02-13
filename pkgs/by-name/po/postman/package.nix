{
  lib,
  stdenvNoCC,
  fetchurl,
  writeScript,
  callPackage,
}:

let
  pname = "postman";
  version = "11.82.1";

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
        aarch64-darwin = "sha256-7n/9ezPgpon3AEQXmoK/iazOPvRh/pDVy/YBVUwjbkI=";
        aarch64-linux = "sha256-nn6Krn3/z7FkPRJDO7wNhny50YvuWwWWQ9lf9mk8ZGo=";
        x86_64-darwin = "sha256-jN6TbPRkEFH9KyU3owcsrWbJvyIqMT0f8zV9OymiNzY=";
        x86_64-linux = "sha256-PEPMrWrm57SAdaHL6ZWES0Ao7J7vn0TAX9WZ/WCFq6U=";
      };
    };

  passthru.updateScript = writeScript "update-postman" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p nix curl jq common-updater-scripts
    set -eou pipefail
    latestVersion=$(curl --fail --silent 'https://dl.pstmn.io/update/status?currentVersion=11.0.0&platform=osx_arm64' | jq --raw-output .version)
    if [[ "$latestVersion" == "$UPDATE_NIX_OLD_VERSION" ]]; then
      exit 0
    fi
    update-source-version postman $latestVersion
    systems=$(nix --extra-experimental-features nix-command eval --json -f . postman.meta.platforms | jq --raw-output '.[]')
    for system in $systems; do
      hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix --extra-experimental-features nix-command eval --raw -f . postman.src.url --system "$system")))
      update-source-version postman $latestVersion $hash --system=$system --ignore-same-version --ignore-same-hash
    done
  '';

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
    mainProgram = "postman";
  };
in

if stdenvNoCC.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      src
      passthru
      meta
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      src
      passthru
      meta
      ;
  }
