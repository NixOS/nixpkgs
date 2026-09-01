{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  mkJetBrainsProduct,
  mkJetBrainsSource,
  maven,
  zlib,
}:

let
  inherit (lib) escapeShellArg;

  version = "2026.2.1";
  buildNumber = "262.9437.185";

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

  src = mkJetBrainsSource {
    # update-script-start: source-args
    inherit version buildNumber;
    buildType = "idea";
    ideaHash = "sha256-iwT2QqmLtsbNyQgoBY26pfxXVEzjSnQ99Ort63a9GXo=";
    androidHash = "sha256-poTjTGR10Ne8VKDWApgu+XcCFMLiAacSFYpIp1tsgbk=";
    jpsHash = "sha256-nxjoLBpiHYzeYwgjbCSSjTFQTFOtBJTqz1VkmPzXijs=";
    restarterHash = "sha256-acCmC58URd6p9uKZrm0qWgdZkqu9yqCs23v8qgxV2Ag=";
    mvnDeps = ../source/idea_maven_artefacts.json;
    kotlin-jps-plugin = {
      version = kotlinDistVersion;
      hash = "sha256-o5R0gSzaSOkK4omBxNf9AsnD6bOsASS416fbqqOAPmE=";
    };
    repositories = [
      "repo1.maven.org/maven2"
      "packages.jetbrains.team/maven/p/ij/intellij-dependencies"
      "dl.google.com/dl/android/maven2"
      "download.jetbrains.com/teamcity-repository"
      "packages.jetbrains.team/maven/p/grazi/grazie-platform-public"
      "packages.jetbrains.team/maven/p/kpm/public"
      "packages.jetbrains.team/maven/p/ki/maven"
      "maven.pkg.jetbrains.space/public/p/compose/dev"
      "packages.jetbrains.team/maven/p/amper/amper"
      "packages.jetbrains.team/maven/p/kt/bootstrap"
    ];
    # update-script-end: source-args

    kotlinHome = kotlinDist;
    # 2026.2 renamed some downloader helpers; the 2025.3 no-download.patch does not apply.
    noDownloadPatch = ../patches/no-download-2026.2.patch;
    # Skip jps-bootstrap network fetches; compile multiplatformSupport sources it now needs.
    jpsBootstrapPatches = [ ../patches/jps-bootstrap-2026.2.patch ];
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
        source ${../source/fix-kotlin-compile.sh}
      )
    '';
  };

in
mkJetBrainsProduct {
  inherit src;
  inherit (src)
    version
    buildNumber
    libdbm
    fsnotifier
    ;

  pname = "idea-oss";

  wmClass = "jetbrains-idea-ce";
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
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
