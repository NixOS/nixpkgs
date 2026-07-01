{
  lib,
  fetchurl,
  jdk25_headless,
  makeWrapper,
  maven,
  stdenvNoCC,
  testers,
}:
let
  # Maven 4 defaults to the latest LTS JDK. Bump this binding to change it.
  jdk_headless = jdk25_headless;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "maven";
  version = "4.0.0-rc-5";

  src = fetchurl {
    url = "mirror://apache/maven/maven-4/${finalAttrs.version}/binaries/apache-maven-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-7OalyZ09BBx25/7RgU656jogoSC8s8I1pz0sTo2xbKE=";
  };

  sourceRoot = ".";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/maven
    cp -r apache-maven-${finalAttrs.version}/* $out/maven

    makeWrapper $out/maven/bin/mvn $out/bin/mvn \
      --set-default JAVA_HOME "${jdk_headless}"
    makeWrapper $out/maven/bin/mvnDebug $out/bin/mvnDebug \
      --set-default JAVA_HOME "${jdk_headless}"

    runHook postInstall
  '';

  passthru = {
    # Reuse maven's builder so build-maven-package.nix is not duplicated.
    buildMavenPackage = maven.mkBuildMavenPackage finalAttrs.finalPackage;

    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = ''
          env MAVEN_OPTS="-Dmaven.repo.local=$TMPDIR/m2" \
            mvn --version
        '';
      };
    };
  };

  meta = {
    homepage = "https://maven.apache.org/";
    description = "Build automation tool (used primarily for Java projects)";
    longDescription = ''
      Apache Maven is a software project management and comprehension
      tool. Based on the concept of a project object model (POM), Maven can
      manage a project's build, reporting and documentation from a central piece
      of information.
    '';
    changelog = "https://maven.apache.org/docs/${finalAttrs.version}/release-notes.html";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.asl20;
    mainProgram = "mvn";
    maintainers = with lib.maintainers; [
      tricktron
      britter
    ];
    teams = [ lib.teams.java ];
    inherit (jdk_headless.meta) platforms;
  };
})
