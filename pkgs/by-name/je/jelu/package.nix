{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jre_minimal,
  nixosTests,
}:
let
  jre = jre_minimal.override {
    modules = [
      "java.base"
      "java.compiler"
      "java.desktop"
      "java.instrument"
      "java.logging"
      "java.management"
      "java.naming"
      "java.net.http"
      "java.prefs"
      "java.scripting"
      "java.security.jgss"
      "java.sql"
      "java.sql.rowset"
      "java.transaction.xa"
      "java.xml"
      "jdk.charsets"
      "jdk.crypto.ec"
      "jdk.localedata"
      "jdk.management"
      "jdk.unsupported"
    ];
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jelu";
  version = "0.80.0";
  strictDeps = true;
  __structuredAttrs = true;
  src = fetchurl {
    url = "https://github.com/bayang/jelu/releases/download/v${finalAttrs.version}/jelu-${finalAttrs.version}.jar";
    hash = "sha256-ThpnjVUsp7VQ+Eil+e0WvxoU3fRv4NP0t4eK1BUBWgQ=";
  };
  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];
  # TODO: Build from source using buildGradleApplication once Gradle build support
  # is more mature. Currently using pre-built JAR due to complex build process
  # combining Java (Gradle) and Node.js (for the web UI).
  installPhase = ''
    runHook preInstall
    install -Dm444 $src $out/share/jelu/jelu.jar
    makeWrapper ${lib.getExe jre} $out/bin/jelu \
      --add-flags "-jar $out/share/jelu/jelu.jar" \
      --set JAVA_HOME ${jre}
    runHook postInstall
  '';
  passthru.tests = {
    inherit (nixosTests) jelu;
  };
  meta = {
    description = "Self hosted read and to-read list book tracker";
    longDescription = ''
      Jelu is a self-hosted book tracking application that allows you to track
      what you have read, what you are reading, and what you want to read.
      It provides an alternative to online services like Goodreads, giving you
      full control over your reading data.
    '';
    homepage = "https://github.com/bayang/jelu";
    changelog = "https://github.com/bayang/jelu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ m0streng0 ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    mainProgram = "jelu";
  };
})
