{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "craft-docs";
  version = "2.8.8";

  src = fetchurl {
    name = "Craft.dmg";
    url = "https://res.craft.do/native/sparkle/Craft.dmg";
    hash = "sha256-5IlzPLzUZmMFEyL2tNDXjvb86/CW4dscVzbnNipKrek=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Craft.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Craft.app
    cp -R . $out/Applications/Craft.app

    runHook postInstall
  '';

  meta = {
    description = "Proprietary note-taking and document-writing software.";
    homepage = "https://craft.do/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ lylythechosenone ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
