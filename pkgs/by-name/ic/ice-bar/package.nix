{
  lib,
  stdenvNoCC,
  unzip,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ice-bar";
  version = "0.9.0";

  src = fetchurl {
    url = "https://github.com/jordanbaird/Ice/releases/download/${finalAttrs.version}/Ice.zip";
    hash = "sha256-MvkJRP8Stz9VIK3vBnWezVKq2KkPfUa/NUBxJtYzHhU=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r *.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Powerful menu bar manager for macOS";
    homepage = "https://icemenubar.app/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donteatoreo ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
