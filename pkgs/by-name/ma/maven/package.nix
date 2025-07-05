{
  lib,
  callPackage,
  fetchurl,
  jdk_headless,
  makeWrapper,
  stdenvNoCC,
  testers,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "maven";
  version = "3.9.10";

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${finalAttrs.version}/binaries/apache-maven-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-4DYFmwrGPNzJNK//qhJcm/P0pM0tK5mV4a7pIZCgl5w=";
  };

  sourceRoot = ".";

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

  passthru =
    let
      makeOverridableMavenPackage =
        mavenRecipe: mavenArgs:
        let
          drv = mavenRecipe mavenArgs;
          overrideWith =
            newArgs: mavenArgs // (if lib.isFunction newArgs then newArgs mavenArgs else newArgs);
        in
        drv
        // {
          overrideMavenAttrs = newArgs: makeOverridableMavenPackage mavenRecipe (overrideWith newArgs);
        };
    in
    {
      buildMaven = callPackage ./build-maven.nix {
        maven = finalAttrs.finalPackage;
      };

      buildMavenPackage = makeOverridableMavenPackage (
        callPackage ./build-maven-package.nix {
          maven = finalAttrs.finalPackage;
        }
      );
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
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.asl20;
    mainProgram = "mvn";
    maintainers = with lib.maintainers; [ tricktron ];
    teams = [ lib.teams.java ];
    inherit (jdk_headless.meta) platforms;
  };
})
