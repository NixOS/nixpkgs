{
  # keep-sorted start
  fetchurl,
  fsnotifier,
  jetbrains,
  lib,
  maven,
  stdenv,
  stdenvNoCC,
  unzip,
  zlib,
  # keep-sorted end
}:

let
  inherit (lib) escapeShellArg;

  # compose-compiler-plugin-for-ide 2.4.20-ij262-34 needs IR APIs from this snapshot.
  kotlinDistVersion = "2.4.20-ij262-34";
  kotlinIdeOldVersion = "2.3.20";

  kotlinDist = stdenvNoCC.mkDerivation {
    pname = "kotlin-dist-for-ide";
    version = kotlinDistVersion;

    src = fetchurl {
      url = "https://cache-redirector.jetbrains.com/intellij-dependencies/org/jetbrains/kotlin/kotlin-dist-for-ide/${kotlinDistVersion}/kotlin-dist-for-ide-${kotlinDistVersion}.jar";
      hash = "sha256-gzTs22ps2Em9Sp0l85EMjuFrLz5AuxXCxXB5JQMcROI=";
    };

    nativeBuildInputs = [ unzip ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      unzip -q $src -d $out
      runHook postInstall
    '';
  };

  src = jetbrains.mkJetBrainsSource (
    lib.importJSON ./source_args.json
    // {
      jbr = jetbrains.jdk-no-jcef;
      mvnDeps = ./maven_artefacts.json;
      kotlinHome = kotlinDist;
      noDownloadPatch = ../../../applications/editors/jetbrains/patches/no-download-2026.2.patch;
      jpsBootstrapPatches = [ ../../../applications/editors/jetbrains/patches/jps-bootstrap-2026.2.patch ];
      jpsBootstrapJavaFlags = [
        "--add-exports java.base/sun.nio.ch=ALL-UNNAMED"
        "--add-exports java.base/jdk.internal.ref=ALL-UNNAMED"
        "--add-opens java.base/jdk.internal.ref=ALL-UNNAMED"
        "--add-opens java.base/java.util=ALL-UNNAMED"
        "--add-opens java.base/java.lang=ALL-UNNAMED"
        "--add-opens java.base/sun.nio.ch=ALL-UNNAMED"
      ];
      copyM2Repo = true;
      extraPostPatch = ''
        for artefact in kotlin-dist-for-ide kotlin-jps-plugin-classpath kotlin-jps-plugin-tests-for-ide; do
          find . -type f -name '*.xml' -exec sed -i \
            -e "s|''${artefact}:${kotlinIdeOldVersion}|''${artefact}:${kotlinDistVersion}|g" \
            -e "s|''${artefact}/${kotlinIdeOldVersion}|''${artefact}/${kotlinDistVersion}|g" \
            -e "s|''${artefact}-${kotlinIdeOldVersion}|''${artefact}-${kotlinDistVersion}|g" \
            {} +
        done
        export COMPOSE_COMPILER_PLUGIN="$repo/.m2/repository/org/jetbrains/kotlin/compose-compiler-plugin-for-ide/${kotlinDistVersion}/compose-compiler-plugin-for-ide-${kotlinDistVersion}.jar"
        export KOTLIN_IDE_NEW=${escapeShellArg kotlinDistVersion}
        (
          set -euo pipefail
          source ${../../../applications/editors/jetbrains/source/fix-kotlin-compile.sh}
        )
      '';
    }
  );
in
jetbrains.mkJetBrainsProduct {
  inherit src fsnotifier;
  inherit (src)
    version
    buildNumber
    ;
  # this is jetbrains-libdbm but using the sources from the IDE build.
  jetbrains-libdbm = src.libdbm;

  # the jdk is bundled on Darwin.
  jdk = if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk then jetbrains.jdk else null;

  pname = "intellij-idea-oss";

  wmClass = "jetbrains-idea";
  product = "IntelliJ IDEA Open Source";
  productShort = "IDEA";

  extraLdPath = [ zlib ];
  extraWrapperArgs = [
    ''--set M2_HOME "${maven}/maven"''
    ''--set M2 "${maven}/maven/bin"''
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/idea/";
    changelog = "https://blog.jetbrains.com/idea/2026/08/intellij-idea-2026-2-1/";
    description = "Free Java, Kotlin, Groovy and Scala IDE from JetBrains (built from source)";
    longDescription = ''
      IDE for Java SE, Groovy & Scala development Powerful environment for building Google Android apps Integration with JUnit, TestNG, popular SCMs, Ant & Maven.
      Also known as IntelliJ.
    '';
    maintainers = with lib.maintainers; [
      gytis-ivaskevicius
      tymscar
    ];
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
