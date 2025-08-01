{
  lib,
  stdenv,
  fetchurl,
}:
let
  # This derivation is adapted from the
  # install script that Chalk recommends: https://api.chalk.ai/install.sh
  chalkVersion = "1.29.4";
  chalkPathPiecesByNixSystem = {
    "aarch64-darwin" = "Darwin/aarch64";
    "x86_64-darwin" = "Darwin/x86_64";
    "aarch64-linux" = "Linux/aarch64";
    "x86_64-linux" = "Linux/x86_64";
  };
  chalkHashByNixSystem = {
    "aarch64-darwin" = "sha256-zHPfyeHdHfbxrUhjLJHbLkeuu7WwK4jtYX7bk5wimX0=";
    "x86_64-darwin" = "sha256-D6lBrnBlD+OU5kQv6b6BzK+u7vB91rTtYpz8iBUeWdA=";
    "aarch64-linux" = "sha256-XHaCLxVJbXjPILczDGWLFqP0q/nBO5O2A9lghkvM474=";
    "x86_64-linux" = "sha256-hlNljLJm+m7l+Djni+ATKyWKSGKSDP0YN3CuJ4fXmWg=";
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
