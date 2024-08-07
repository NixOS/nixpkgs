{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sqruff";
  version = "0.11.0";
  src = fetchurl {
    url = "https://github.com/quarylabs/sqruff/releases/download/v${finalAttrs.version}/sqruff-linux-x86_64-musl.tar.gz";
    hash = "sha256-FTBwoOvKHyFXmnpHMdXVBbP7KxY1eSkAodAZtslzhIw=";
  };

  phases = [
    "unpackPhase"
    "installPhase"
    "patchPhase"
  ];

  sourceRoot = ".";

  installPhase = ''
    install -Dm755 sqruff -t $out/bin
  '';

  meta = {
    description = "Fast SQL formatter/linter";
    license = lib.licenses.asl20;
    mainProgram = "sqruff";
    maintainers = with lib.maintainers; [ cafkafk ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
