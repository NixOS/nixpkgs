{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "closure-compiler";
  version = "20260128";

  src = fetchurl {
    url = "mirror://maven/com/google/javascript/closure-compiler/v${finalAttrs.version}/closure-compiler-v${finalAttrs.version}.jar";
    sha256 = "sha256-GlloHdQBhil/++qld8+yyYpNmCACYxjW8QW0YtPTOVk=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    mkdir -p $out/share/java $out/bin
    cp ${finalAttrs.src} $out/share/java/closure-compiler-v${finalAttrs.version}.jar
    makeWrapper ${jre}/bin/java $out/bin/closure-compiler \
      --add-flags "-jar $out/share/java/closure-compiler-v${finalAttrs.version}.jar"
  '';

  meta = {
    description = "Tool for making JavaScript download and run faster";
    mainProgram = "closure-compiler";
    homepage = "https://developers.google.com/closure/compiler/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
