{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "google-java-format";
  version = "1.37.0";
  __structuredAttrs = true;

  src = fetchurl {
    sha256 = "sha256-g0sqDDjLd0lTMiqEtco/L0DdMVZlCzzUTTt0Q0WWL3o=";
    url = "https://github.com/google/google-java-format/releases/download/v${finalAttrs.version}/google-java-format-${finalAttrs.version}-all-deps.jar";
    meta.identifiers.purlParts = {
      type = "github";
      spec = "google/google-java-format@${version}";
    };
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${finalAttrs.pname}}
    install -D ${finalAttrs.src} $out/share/${finalAttrs.pname}/google-java-format-${finalAttrs.version}-all-deps.jar

    makeWrapper ${jre}/bin/java $out/bin/${finalAttrs.pname} \
      --argv0 ${finalAttrs.pname} \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED" \
      --add-flags "-jar $out/share/${finalAttrs.pname}/google-java-format-${finalAttrs.version}-all-deps.jar"

    runHook postInstall
  '';

  meta = {
    description = "Java source formatter by Google";
    longDescription = ''
      A program that reformats Java source code to comply with Google Java Style.
    '';
    homepage = "https://github.com/google/google-java-format";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.emptyflask ];
    platforms = lib.platforms.all;
    mainProgram = "google-java-format";
  };
})
