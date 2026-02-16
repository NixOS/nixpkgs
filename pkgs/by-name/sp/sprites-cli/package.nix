{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  platform =
    {
      x86_64-linux = {
        os = "linux";
        arch = "amd64";
        sha256 = "sha256-tzM19cI1P83l1ioKRvTqE2ThXiP62JZzFbjBWVUqtQw=";
      };
      aarch64-linux = {
        os = "linux";
        arch = "arm64";
        sha256 = "sha256-hRv0DfUsZQdCVOeXkbJ7tvnCypopeYD8z/+LkN+p0ic=";
      };
      x86_64-darwin = {
        os = "darwin";
        arch = "amd64";
        sha256 = "sha256-UCNr5irx1x0xb+D9HjWgc46ESlq5Te8pbKsAcYujBYM=";
      };
      aarch64-darwin = {
        os = "darwin";
        arch = "arm64";
        sha256 = "sha256-ULgnFMqG+wPEhMomeNhqwhokAcsIgFlvw4qA18CxyYc=";
      };
    }
    .${system} or throwSystem;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sprites-cli";
  version = "0.0.1-rc31";

  src = fetchurl {
    url = "https://sprites-binaries.t3.storage.dev/client/v${finalAttrs.version}/sprite-${platform.os}-${platform.arch}.tar.gz";
    sha256 = platform.sha256;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    tar -xzf $src
    found="$(find . -type f -name sprite -print -quit)"
    if [ -z "$found" ]; then
      echo "sprite binary not found after unpack" >&2
      exit 1
    fi
    install -Dm755 "$found" $out/bin/sprite
    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line interface for Fly.io Sprites";
    homepage = "https://sprites.dev/";
    license = licenses.unfreeRedistributable;
    mainProgram = "sprite";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ananthb ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
