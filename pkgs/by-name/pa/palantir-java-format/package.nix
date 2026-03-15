{
  lib,
  stdenv,
  jre,
  coursier,
  makeWrapper,
  setJavaClassPath,
}:

let
  pname = "palantir-java-format";
  version = "2.89.0";
  deps = stdenv.mkDerivation {
    name = "${pname}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch com.palantir.javaformat:palantir-java-format:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHash = "sha256-JirfOzmNFEXHV57YNEwIzyuWrY0bcvEUj7KXsTzOJkw=";
  };
in
stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [
    makeWrapper
    setJavaClassPath
  ];
  buildInputs = [ deps ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED" \
      --add-flags "-cp $CLASSPATH com.palantir.javaformat.java.Main"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/palantir-java-format --version 2>&1 | grep -q "${version}"
  '';

  meta = {
    description = "Modern, lambda-friendly, 120 character Java formatter based on google-java-format";
    homepage = "https://github.com/palantir/palantir-java-format";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.tomeraberbach ];
    platforms = lib.platforms.all;
    mainProgram = "palantir-java-format";
  };
}
