{
  maven,
  lib,
  fetchFromGitHub,
  jre_minimal,
  makeWrapper,
  nix-update-script,
}:
maven.buildMavenPackage rec {
  pname = "jol";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "OpenJDK";
    repo = "jol";
    tag = version;
    hash = "sha256-ZJFuY2QYB8eUS3y3VRMGGwklCS93HHVkNe/dhyIx0SY=";
  };

  mvnHash = "sha256-yQfiHlAZZgINGAYVlK5JflWX3d8Axtv1Ke89S7x86G4=";

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace jol-cli/src/main/java/org/openjdk/jol/Main.java \
      --replace-fail 'Usage: jol-cli.jar' 'Usage: jol-cli'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 jol-cli/target/jol-cli.jar $out/share/jol-cli/jol-cli.jar
    makeWrapper ${lib.getExe' jre_minimal "java"} $out/bin/jol-cli \
      --add-flags "-jar $out/share/jol-cli/jol-cli.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Java Object Layout (JOL)";
    longDescription = ''
      JOL (Java Object Layout) is the tiny toolbox to analyze object layout in JVMs.
      These tools are using Unsafe, JVMTI, and Serviceability Agent (SA) heavily to decode the actual object layout, footprint, and references.
      This makes JOL much more accurate than other tools relying on heap dumps, specification assumptions, etc.
    '';
    homepage = "https://openjdk.org/projects/code-tools/jol/";
    changelog = "https://github.com/openjdk/jol/releases/tag/${version}";
    license = with lib.licenses; [
      gpl2Plus
      classpathException20
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    mainProgram = "jol-cli";
    maintainers = with lib.maintainers; [
      debling
      progrm_jarvis
    ];
    inherit (jre_minimal.meta) platforms;
  };
}
