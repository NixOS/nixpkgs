{ fetchMavenArtifact, addSettings }:

addSettings
  (fetchMavenArtifact {
    groupId = "com.github.weisj";
    artifactId = "jsvg";
    version = "2.0.0";
    hash = "sha256-gfya2lefw/SSTsNfkEwEPeE+6PuigDIuY4xwkgBvG1I=";
  })
  (finalAttrs: ''
    ISABELLE_JSVG_HOME="${finalAttrs.finalPackage}"

    classpath "$ISABELLE_JSVG_HOME/share/java/jsvg-${finalAttrs.version}.jar";
  '')
