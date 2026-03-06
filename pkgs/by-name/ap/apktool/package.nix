{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre_minimal,
  aapt,
}:

let
  jre = jre_minimal.override {
    modules = [
      "java.base"
      "java.desktop"
      "java.logging"
      "java.xml"
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "apktool";
  version = "2.12.1";

  src = fetchurl {
    urls = [
      "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${finalAttrs.version}.jar"
      "https://github.com/iBotPeaches/Apktool/releases/download/v${finalAttrs.version}/apktool_${finalAttrs.version}.jar"
    ];
    hash = "sha256-Zs9FJKSkWn9WVn0Issm27CN7zdeM7mn9SlnIoCQ66vo=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = ".";

  installPhase = ''
    install -D ${finalAttrs.src} "$out/libexec/apktool/apktool.jar"
    mkdir -p "$out/bin"
    makeWrapper "${jre}/bin/java" "$out/bin/apktool" \
        --add-flags "-jar $out/libexec/apktool/apktool.jar" \
        --prefix PATH : ${lib.getBin aapt}
  '';

  meta = {
    description = "Tool for reverse engineering Android apk files";
    mainProgram = "apktool";
    homepage = "https://ibotpeaches.github.io/Apktool/";
    changelog = "https://github.com/iBotPeaches/Apktool/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
})
