{
  stdenvNoCC,
  writableTmpDirAsHomeHook,
  isabelleWithJars,
  lib,
  writeTextFile,
  pkgs,
  isabelle,
  runCommand,
}:

stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    settings = writeTextFile {
      name = "naproche-settings";
      text = ''
        NAPROCHE_HOME="@out@/share/naproche"
        ISABELLE_NAPROCHE="$NAPROCHE_HOME/Isabelle"
        init_component "$ISABELLE_NAPROCHE/Admin"
        NAPROCHE_EXE="${lib.getExe' pkgs.naproche ".Naproche-wrapped"}"
        ISABELLE_DOCS_EXAMPLES="$ISABELLE_DOCS_EXAMPLES:\$ISABELLE_NAPROCHE/Intro.thy"
        NAPROCHE_EPROVER="$E_HOME/eprover"
        NAPROCHE_SPASS="$SPASS_HOME/SPASS"
        NAPROCHE_VAMPIRE="$VAMPIRE_HOME/vampire"
        NAPROCHE_MATH="$NAPROCHE_HOME/math"
        NAPROCHE_ARCHIVE="$NAPROCHE_MATH/archive"
        NAPROCHE_FORMALIZATIONS="$(platform_path "$NAPROCHE_MATH")"
        NAPROCHE_MATHHUB="$(platform_path "$NAPROCHE_ARCHIVE")"
        classpath "$ISABELLE_NAPROCHE/naproche.jar"
      '';
    };
  in
  {
    inherit (pkgs.naproche) pname version src;

    outputs = [
      "out"
      "settings"
    ];

    nativeBuildInputs = [
      writableTmpDirAsHomeHook
      isabelleWithJars
    ];

    buildPhase = ''
      runHook preBuild

      isabelle components -u $(pwd)
      isabelle scala_build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm644 etc/options $settings/etc/options
      substitute ${settings} $settings/etc/settings \
        --replace-fail '@out@' "$out"
      rm -rf etc

      mkdir -p $out/share/naproche
      cp -r ./* $out/share/naproche

      runHook postInstall
    '';

    # TODO: See if failure is expected
    passthru.tests.isabelle =
      runCommand "isabelle-naproche-test"
        {
          nativeBuildInputs = [
            writableTmpDirAsHomeHook
            isabelle
          ];
        }
        ''
          isabelle naproche_test
          touch $out
        '';

    meta = {
      description = "Write formal proofs in natural language and LaTeX.";
      homepage = "https://naproche.github.io/";
      license = lib.licenses.gpl3;
      maintainers = [
        lib.maintainers.sempiternal-aurora
      ];
      platforms = isabelle.meta.platforms;
    };
  }
)
