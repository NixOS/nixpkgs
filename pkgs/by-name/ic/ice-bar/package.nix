{
  lib,
  stdenvNoCC,
  unzip,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ice-bar";
  version = "0.11.11";

  src = fetchurl {
    url = "https://github.com/jordanbaird/Ice/releases/download/${finalAttrs.version}/Ice.zip";
    hash = "sha256-Iepf+mFN7ym7aZu3xnJVJoQNDZmSFvt15QTGdXtvScs=";
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
