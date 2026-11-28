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
  # The 2026.3 tree pins Kotlin 2.4.21-RC in .idea/kotlinc.xml and is developed
  # against JBR 25. The JPS build in source/build.nix still defaults to the
  # 2025.3 toolchain (still used by pycharm-oss), so pass these explicitly.
  kotlinVersion = "2.4.21-RC";
  composeCompilerVersion = kotlinVersion;
  jcefBuild = "263-b16";
  jcefArch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x64";

  # The source tree refers to this jar through the $KOTLIN_COMPOSE_COMPILER_PLUGIN$ macro.
  composeCompilerPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/org/jetbrains/kotlin/kotlin-compose-compiler-plugin-embeddable/${composeCompilerVersion}/kotlin-compose-compiler-plugin-embeddable-${composeCompilerVersion}.jar";
    hash = "sha256-guRSI++j50B/a9hnV4cuuEU6Ruq7VO8iJV9yWxfvUzQ=";
  };

  # Upstream's compiler distribution for this release, so the compiler matches
  # the kotlin-jps-plugin-classpath jar recorded in source_args.json.
  kotlinDist = stdenvNoCC.mkDerivation {
    pname = "kotlin-dist-for-ide";
    version = kotlinVersion;

    src = fetchurl {
      url = "https://packages.jetbrains.team/maven/p/ij/intellij-dependencies/org/jetbrains/kotlin/kotlin-dist-for-ide/${kotlinVersion}/kotlin-dist-for-ide-${kotlinVersion}.jar";
      hash = "sha256-+Bpd3wanezqYCCxvEi39RWgLfH31Y1VPb+DcUC/zV2A=";
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

  # The JCEF plugin binaries are normally downloaded while building the distribution.
  jcefArchive = fetchurl {
    url = "https://cache-redirector.jetbrains.com/intellij-jbr/jcef-linux-${jcefArch}-${jcefBuild}.tar.gz";
    hash = {
      x64 = "sha256-rMmW7P+kPXcux5YpTek6a1UmszR4wPdswWq1+RdHTJ0=";
      aarch64 = "sha256-s2vJRKRZDagNm4dWqqnlH6Fux4oBo77dOmsFtclp7Zs=";
    }.${jcefArch};
  };

  src = jetbrains.mkJetBrainsSource (
    lib.importJSON ./source_args.json
    // {
      jbr = jetbrains.jdk-no-jcef;
      kotlinHome = kotlinDist;
      mvnDeps = ./maven_artefacts.json;

      noDownloadPatch = ../../../applications/editors/jetbrains/patches/no-download-2026.3.patch;
      sbomPatch = ../../../applications/editors/jetbrains/patches/disable-sbom-generation-2026.3.patch;
      jacksonPatch = ../../../applications/editors/jetbrains/patches/bump-jackson-core-in-source-2026.3.patch;
      extraPatches = [
        ../../../applications/editors/jetbrains/patches/jps-compilation-2026.3.patch
      ];
      jpsBootstrapPatches = [
        ../../../applications/editors/jetbrains/patches/jps-bootstrap-2026.3.patch
      ];
      jpsBootstrapJavaFlags = [
        "--add-exports=java.base/sun.nio.ch=ALL-UNNAMED"
        "--add-exports=java.base/jdk.internal.ref=ALL-UNNAMED"
        "--add-opens=java.base/jdk.internal.ref=ALL-UNNAMED"
        "--add-opens=java.base/java.util=ALL-UNNAMED"
        "--add-opens=java.base/java.lang=ALL-UNNAMED"
        "--add-opens=java.base/sun.nio.ch=ALL-UNNAMED"
      ];
      copyM2Repo = true;
      composeCompilerPlugin = composeCompilerPlugin;
      jcefArchive = jcefArchive;
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
    changelog = "https://www.jetbrains.com/idea/whatsnew/";
    description = "Free Java, Kotlin, Groovy and Scala IDE from JetBrains (built from source)";
    longDescription = ''
      IDE for Java SE, Groovy & Scala development Powerful environment for building Google Android apps Integration with JUnit, TestNG, popular SCMs, Ant & Maven.
      Also known as IntelliJ.
    '';
    maintainers = with lib.maintainers; [
      charlieprm88
      tymscar
    ];
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
