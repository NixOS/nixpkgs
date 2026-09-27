{
  stdenvNoCC,
  perl,
  scala,
  jdk,
  flatlaf,
  isabelle,
  writeTextFile,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "isabelle-setup";
  inherit (isabelle) src version;

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = ''
    substituteInPlace src/Tools/Setup/src/Environment.java \
      --replace-fail 'cmd.add("/usr/bin/env");' "" \
      --replace-fail 'cmd.add("bash");' "cmd.add(\"$SHELL\");"
  '';

  nativeBuildInputs = [
    jdk
    perl
  ];

  buildInputs = [
    flatlaf
    scala
  ];

  extraAutoPatchelfLibs = [
    "${jdk}/lib/openjdk/lib"
  ];

  buildPhase = ''
    runHook preBuild

    # The following is adapted from https://isabelle.in.tum.de/repos/isabelle/file/Isabelle2021-1/Admin/lib/Tools/build_setup
    TARGET_DIR="build"
    rm -rf "$TARGET_DIR"
    mkdir -p "$TARGET_DIR/isabelle/setup"
    declare -a ARGS=("-Xlint:unchecked")

    SOURCES="$(${perl}/bin/perl -e 'while (<>) { if (m/(\S+\.java)/)  { print "$1 "; } }' "src/Tools/Setup/etc/build.props")"
    for SRC in $SOURCES
    do
      ARGS["''${#ARGS[@]}"]="src/Tools/Setup/$SRC"
    done
    CLASSPATH="${scala}/lib/scala3-interfaces-${scala.version}.jar:${scala}/lib/scala3-compiler_3-${scala.version}.jar:${flatlaf}/share/java/flatlaf-${flatlaf.version}-no-natives.jar"
    javac -d "$TARGET_DIR" -classpath "$CLASSPATH" "''${ARGS[@]}"
    jar -c -f "$TARGET_DIR/isabelle_setup.jar" -e "isabelle.setup.Setup" -C "$TARGET_DIR" isabelle

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 $TARGET_DIR/isabelle_setup.jar $out/lib/isabelle_setup.jar
    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "setup-settings";
    text = ''
      ISABELLE_SETUP_JAR=${finalAttrs.finalPackage}/lib/isabelle_setup.jar
      classpath "$ISABELLE_SETUP_JAR"
    '';
    destination = "/etc/settings";
  };
})
