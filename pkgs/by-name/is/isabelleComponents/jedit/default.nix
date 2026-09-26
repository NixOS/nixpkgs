{
  stdenvNoCC,
  fetchurl,
  writeTextFile,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jedit";
  version = "20251128";

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/jedit-${finalAttrs.version}.tar.gz";
    hash = "sha256-3Hv6rvD+XP1e25TCSJKIcC92+ZUeA+N2BS8eb1DVny4=";
  };
  sourceRoot = "jedit-${finalAttrs.version}/jedit5.7.0-patched";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{doc,java,jedit}
    cp jedit.jar $out/share/java
    cp -r jars keymaps macros modes properties startup $out/share/jedit
    cp -r doc/* $out/share/doc

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "jedit-settings";
    text = ''
      JEDIT_HOME="${finalAttrs.finalPackage}/share/jedit"
      JEDIT_JAR_HOME="${finalAttrs.finalPackage}/share/java"
      JEDIT_JARS="$JEDIT_HOME/jars/CommonControls.jar:$JEDIT_HOME/jars/Console.jar:$JEDIT_HOME/jars/ErrorList.jar:$JEDIT_HOME/jars/Highlight.jar:$JEDIT_HOME/jars/QuickNotepad.jar:$JEDIT_HOME/jars/SideKick.jar:$JEDIT_HOME/jars/jsr305-3.0.2.jar:$JEDIT_HOME/jars/kappalayout.jar"
      JEDIT_JAR="$JEDIT_JAR_HOME/jedit.jar"
      classpath "$JEDIT_JAR"

      JEDIT_SETTINGS="$ISABELLE_HOME_USER/jedit"

      ISABELLE_DOCS="$ISABELLE_DOCS:${finalAttrs.finalPackage}/share/doc"
    '';
    destination = "/etc/settings";
  };
})
