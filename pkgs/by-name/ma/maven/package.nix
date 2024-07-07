{
  lib,
  callPackage,
  fetchurl,
  jdk,
  makeWrapper,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "apache-maven";
  version = "3.9.6";

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${finalAttrs.version}/binaries/apache-maven-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-bu3SyuNibWrTpcnuMkvSZYU9ZCl/B/AzQwdVvQ4MOks=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/maven
    cp -r apache-maven-${finalAttrs.version}/* $out/maven

    makeWrapper $out/maven/bin/mvn $out/bin/mvn \
      --set-default JAVA_HOME "${jdk}"
    makeWrapper $out/maven/bin/mvnDebug $out/bin/mvnDebug \
      --set-default JAVA_HOME "${jdk}"

    runHook postInstall
  '';

  passthru = {
    buildMaven = callPackage ./build-maven.nix {
      maven = finalAttrs.finalPackage;
    };
    buildMavenPackage = callPackage ./build-maven-package.nix {
      maven = finalAttrs.finalPackage;
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
    license = lib.licenses.asl20;
    mainProgram = "mvn";
    maintainers = with lib.maintainers; [ cko ];
    inherit (jdk.meta) platforms;
  };
})
