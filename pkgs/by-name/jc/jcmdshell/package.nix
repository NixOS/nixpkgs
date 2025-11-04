{
  lib,
  maven,
  makeWrapper,
  fetchFromGitHub,
  jdk25,
  runCommand,
}:

let
  version = "0.1.0";
in
maven.buildMavenPackage {
  pname = "jcmdshell";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "StackPancakes";
    repo = "Jcmdshell";
    rev = version;
    hash = "sha256-nbLyi7w0frfAxy0sOrUz0pvl9ADh7bYogWi/dvJhlZ0=";
  };

  mvnHash = "sha256-J7Nkc4MMQm6h32h9/8ik0Tzv7EQkYJorCa23I0Z8xsY=";
  mvnJdk = jdk25;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/jcmdshell
    install -Dm644 target/Jcmdshell-fat.jar $out/share/jcmdshell/jcmdshell.jar

    makeWrapper ${jdk25}/bin/java $out/bin/jcmdshell \
      --add-flags "--enable-native-access=ALL-UNNAMED" \
      --add-flags "-jar $out/share/jcmdshell/jcmdshell.jar"

    runHook postInstall
  '';

  meta = {
    description = "Cross-platform command-line shell built in pure Java, designed around the WORE principle (Write Once, Run Everywhere)";
    homepage = "https://github.com/StackPancakes/Jcmdshell";
    changelog = "https://github.com/StackPancakes/Jcmdshell/releases/tag/${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ xdhampus ];
    mainProgram = "jcmdshell";
    platforms = lib.platforms.all;
  };
}
