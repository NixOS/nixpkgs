{
  lib,
  stdenv,
  fetchurl,
}:
let
  # This derivation is adapted from the
  # install script that Chalk recommends: https://api.chalk.ai/install.sh
  chalkVersion = "1.34.9";
  chalkPathPiecesByNixSystem = {
    "aarch64-darwin" = "Darwin/aarch64";
    "x86_64-darwin" = "Darwin/x86_64";
    "aarch64-linux" = "Linux/aarch64";
    "x86_64-linux" = "Linux/x86_64";
  };
  chalkHashByNixSystem = {
    "aarch64-darwin" = "sha256-owDGsT/2tU1Y3JKWAQkYNG18dOxXIST/3bfjXJf1gXU=";
    "x86_64-darwin" = "sha256-lCRYekUmXFW6V/zvbvWCqzxr0bbpvQwk1wgWtAYuPuQ=";
    "aarch64-linux" = "sha256-uvhjhLbVBGB5SNFbfgtpaeLULFnEm3x8fN9ffyJzSSM=";
    "x86_64-linux" = "sha256-lC5SwvZzYJqomRrK42roSQr4/GZScM2VdgiQ9DOSkHQ=";
  };
  chalkHash = chalkHashByNixSystem."${stdenv.system}";
  chalkPathPieces = chalkPathPiecesByNixSystem."${stdenv.system}";
  chalkUrl = "https://api.chalk.ai/v1/install/${chalkPathPieces}/v${chalkVersion}";
in
stdenv.mkDerivation {
  pname = "chalk";
  version = chalkVersion;
  src = fetchurl {
    url = chalkUrl;
    hash = chalkHash;
  };
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm 555 $src $out/bin/chalk
    runHook postInstall
  '';

  meta = {
    description = "CLI tool for interacting with the Chalk platform";
    homepage = "https://docs.chalk.ai/cli";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ curran ];
    mainProgram = "chalk";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
