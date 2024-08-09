{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sqruff";
  version = "0.11.0";
  src = fetchurl {
    url = "https://github.com/quarylabs/sqruff/releases/download/v{finalAttrs.version}/sqruff-linux-x86_64-musl.tar.gz";
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

  meta = with lib; {
    description = "Fast SQL formatter/linter";
    license = licenses.asl20;
    mainProgram = "sqruff";
    maintainers = with maintainers; [ cafkafk ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
})
