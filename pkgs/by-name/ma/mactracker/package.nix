{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mactracker";
  version = "7.13";

  src = fetchurl {
    url = "https://mactracker.ca/downloads/Mactracker_${finalAttrs.version}.zip";
    hash = "sha256-GbaGhYF9Pf3EpzoLQd9fkWYxHFwCkYdlRyy33lieUxM=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = "Mactracker.app";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    unzip -d $out/Applications $src -x '__MACOSX/*'
    runHook postInstall
  '';

  meta = {
    description = "Mactracker provides detailed information on every Apple Macintosh, iPod, iPhone, iPad, and Apple Watch ever made";
    homepage = "https://mactracker.ca";
    changelog = "https://mactracker.ca/releasenotes-mac.html";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
