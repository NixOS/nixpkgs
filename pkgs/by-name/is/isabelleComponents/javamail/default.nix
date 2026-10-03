{
  stdenvNoCC,
  fetchMavenArtifact,
  writeTextFile,
  lib,
}:

let
  jars = [
    {
      groupId = "org.eclipse.angus";
      artifactId = "angus-activation";
      version = "2.0.3";
      hash = "sha256-pr01xTjPkP/5Qa1iWMQMCPygtcnD9TbGVxFPJ84FJ6c=";
    }
    {
      groupId = "org.eclipse.angus";
      artifactId = "angus-mail";
      version = "2.0.5";
      hash = "sha256-tNjDDTX0Vd72x6Bf5ZWh5i6iuAysPv7B6cz0EYsjFoo=";
    }
    {
      groupId = "jakarta.mail";
      artifactId = "jakarta.mail-api";
      version = "2.1.5";
      hash = "sha256-qkk3U6y3qMRbqPTJzxIwp04gI3BW3Vtci8hsWD6M+g4=";
    }
    {
      groupId = "jakarta.activation";
      artifactId = "jakarta.activation-api";
      version = "2.1.4";
      hash = "sha256-ydtSEAzmyKrJXMOQdflXINLlYbEfgFG4HBIa1O/9cAQ=";
    }
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "javamail";
  version = "20251022";

  srcs = map fetchMavenArtifact jars;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp */share/java/*.jar $out/share/java

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "javamail-settings";
    text = ''
      JAVAMAIL_HOME="${finalAttrs.finalPackage}"
    ''
    + lib.concatLines (
      map (src: "classpath \"$JAVAMAIL_HOME/share/java/${src.artifactId}-${src.version}.jar\"") jars
    );
    destination = "/etc/settings";
  };

  meta = {
    description = "Various javamail jars";
    homepage = "https://isabelle.in.tum.de/";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.AND [
      # angus-activation and jakarta.activation-api license
      lib.licenses.bsd3
      # angus-mail and jakarta.mail-api license
      (lib.licenses.OR [
        (lib.licenses.WITH lib.licenses.gpl2Only lib.licenses.classpathException20)
        lib.licenses.epl20
      ])
    ];
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    platforms = lib.platforms.all;
  };
})
