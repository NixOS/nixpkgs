{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  jre_headless,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bundletool";
  version = "1.18.0";

  src = fetchurl {
    url = "https://github.com/google/bundletool/releases/download/${finalAttrs.version}/bundletool-all-${finalAttrs.version}.jar";
    sha256 = "sha256-eDQ3ZNLnnI9VcQN4sEmB/LHkba6/w7XcV3d4CC5qmP0=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall
    makeWrapper ${jre_headless}/bin/java $out/bin/bundletool --add-flags "-jar $src"
    runHook postInstall
  '';

  meta = {
    description = "Command-line tool to manipulate Android App Bundles";
    mainProgram = "bundletool";
    homepage = "https://developer.android.com/studio/command-line/bundletool";
    changelog = "https://github.com/google/bundletool/releases/tag/${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ momeemt ];
    platforms = jre_headless.meta.platforms;
    license = lib.licenses.asl20;
  };
})
