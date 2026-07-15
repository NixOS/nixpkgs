{
  lib,
  mkJetBrainsProduct,
  mkJetBrainsSource,
  maven,
  zlib,
}:
let
  src = mkJetBrainsSource {
    # update-script-start: source-args
    version = "2025.3.4";
    buildNumber = "253.32098.37";
    buildType = "idea";
    ideaHash = "sha256-5rPaXIGOeWY9tcHRs5p376kgo4EbUtEltwcmNpPSsM8=";
    androidHash = "sha256-uvoDTv/7RlyxRp1d9v2tN9IJkv9d1QEkZpp23hae84k=";
    jpsHash = "sha256-iHpt926BDLNUwHRXvkqVgwlWiLo1qSZEaGeJcS0Fjmk=";
    restarterHash = "sha256-acCmC58URd6p9uKZrm0qWgdZkqu9yqCs23v8qgxV2Ag=";
    mvnDeps = ../source/idea_maven_artefacts.json;
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
    kotlin-jps-plugin = {
      version = "2.2.20";
      hash = "sha256-+jGghK2+yq+YFm5zT7ob+WTgTiJnHXAjDtlZjOzSISQ=";
    };
    # update-script-end: source-args
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
