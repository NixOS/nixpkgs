{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  isabelle,
  writableTmpDirAsHomeHook,
  writeTextFile,
}:

let
  settings = writeTextFile {
    name = "linter-settings";
    text = ''
      JEDIT_LINTER_HOME="@out@/share/jedit_linter"
      ISABELLE_LINTER_JAR="@out@/share/java/isabelle_linter.jar"
      classpath "$ISABELLE_LINTER_JAR"
      classpath "@out@/share/java/isabelle_linter_plugin.jar"
    '';
  };
in
stdenvNoCC.mkDerivation {
  pname = "isabelle-linter";
  version = "2025-2-1.0.0";

  outputs = [
    "out"
    "settings"
  ];

  src = fetchFromGitHub {
    owner = "isabelle-prover";
    repo = "isabelle-linter";
    tag = "Isabelle2025-2-v1.0.0";
    hash = "sha256-V6Bnxyq/WI6U0sVBHA/vFOI0U3Vd5/GLCxbeWVitm8I=";
  };

  nativeBuildInputs = [
    isabelle
    writableTmpDirAsHomeHook
  ];

  buildPhase = ''
    runHook preBuild

    isabelle components -u $(pwd)
    isabelle scala_build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/jedit_linter $out/share/java
    cp -r jedit_linter/jedit_linter_plugin $out/share/jedit_linter
    install -m644 jedit_linter/Linter.thy $out/share/jedit_linter
    install -Dm644 linter_base/lib/classes/isabelle_linter.jar jedit_linter/lib/classes/isabelle_linter_plugin.jar $out/share/java

    mkdir -p $settings/etc
    install -m644 linter_base/etc/options $settings/etc
    tail -n +2 jedit_linter/etc/options >> $settings/etc/options
    substitute ${settings} $settings/etc/settings --replace-fail '@out@' "$out"

    runHook postInstall
  '';

  meta = {
    description = "Linter component for Isabelle";
    homepage = "https://github.com/isabelle-prover/isabelle-linter";
    maintainers = with lib.maintainers; [
      jvanbruegge
      sempiternal-aurora
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
