{
  maven,
  lib,
  fetchFromGitHub,
  openjdk,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:
let
  jdk = openjdk.override {
    enableJavaFX = true;
  };
in
maven.buildMavenPackage rec {
  pname = "jitwatch";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "AdoptOpenJDK";
    repo = "jitwatch";
    tag = version;
    hash = "sha256-ytLjIxfFqy56FsfZUMI7kuOCFr8xKUl8cGpQFM99+0E=";
  };

  mvnHash = "sha256-J25Ff0xbyKzKPA5MRj4+S43sLKwaSC8SvectmxRoiVI=";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "jitwatch";
      exec = "jitwatch";
      terminal = false;
      desktopName = "JITWatch";
      genericName = "Log analyser and visualiser for the HotSpot JIT compiler";
      comment = "Inspect inlining decisions, hot methods, bytecode, and assembly. View results in the JavaFX user interface.";
      categories = [
        "Development"
        "Debugger"
        "Profiling"
        "Java"
      ];
      startupWMClass = "org.adoptopenjdk.jitwatch.ui.main.JITWatchUI";
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 ui/target/jitwatch-ui-shaded.jar $out/share/jitwatch/jitwatch.jar
    makeWrapper ${lib.getExe' jdk "java"} $out/bin/jitwatch \
      --add-flags "-jar $out/share/jitwatch/jitwatch.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Log analyser and visualiser for the HotSpot JIT compiler";
    longDescription = ''
      Log analyser / visualiser for Java HotSpot JIT compiler.
      Inspect inlining decisions, hot methods, bytecode, and assembly.
      View results in the JavaFX user interface.
    '';
    homepage = "https://github.com/AdoptOpenJDK/jitwatch/wiki";
    changelog = "https://github.com/AdoptOpenJDK/jitwatch/releases/tag/${version}";
    license = lib.licenses.bsd2;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    mainProgram = "jitwatch";
    maintainers = [ lib.maintainers.progrm_jarvis ];
    inherit (jdk.meta) platforms;
  };
}
