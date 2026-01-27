{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre_headless,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "jelu";
  version = "0.77.0";

  src = fetchurl {
    url = "https://github.com/bayang/jelu/releases/download/v${finalAttrs.version}/jelu-${finalAttrs.version}.jar";
    hash = "sha256-OpICgMQB04vTfx0+UETy2MM5Us7iRwY6eXFLrHCMG+E=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  # TODO: Build from source using buildGradleApplication once Gradle build support
  # is more mature. Currently using pre-built JAR due to complex build process
  # combining Java (Gradle) and Node.js (for the web UI).
  installPhase = ''
    runHook preInstall

    install -Dm444 $src $out/share/jelu/jelu.jar

    makeWrapper ${lib.getExe jre_headless} $out/bin/jelu \
      --add-flags "-jar $out/share/jelu/jelu.jar" \
      --set JAVA_HOME ${jre_headless}

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
