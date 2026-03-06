{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "google-java-format";
  version = "1.34.1";

  src = fetchurl {
    url = "https://github.com/google/google-java-format/releases/download/v${version}/google-java-format-${version}-all-deps.jar";
    sha256 = "sha256-eeHLXIvWmMVywK5QTQeBYSm4/AYgT7SVUL7IO9XqCqg=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}}
    install -D ${src} $out/share/${pname}/google-java-format-${version}-all-deps.jar

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --argv0 ${pname} \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED" \
      --add-flags "-jar $out/share/${pname}/google-java-format-${version}-all-deps.jar"

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
}
