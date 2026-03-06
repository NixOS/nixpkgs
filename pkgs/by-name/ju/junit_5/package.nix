{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  git,
  jdk8, # to build Vintage
  jdk,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "junit";
  version = "5.14.3";

  src = fetchFromGitHub {
    owner = "junit-team";
    repo = "junit5";
    tag = "r${finalAttrs.version}";
    hash = "sha256-Cg4ehX4/IVNLsQ0wr4wdRS0rNUABy9VUfwHHyHXwR3U=";
  };

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  nativeBuildInputs = [
    gradle
    git
    jdk
  ];

  gradleBuildTask = "assemble";

  gradleCheckTask = "";
  dontCheck = true;

  gradleFlags = [
    "-Porg.gradle.java.installations.auto-download=false"
    "-Porg.gradle.java.installations.paths=${jdk8.home},${jdk.home}"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java

    find . -name "*-${finalAttrs.version}.jar" ! -name "*-javadoc.jar" ! -name "*-sources.jar" -exec cp {} $out/share/java/ \;

    runHook postInstall
  '';

  preBuild = ''
    git init
    git config user.name "Nix"
    git config user.email "nix@localhost"
    git add .
    git commit -m "fake commit"
    git tag "r${finalAttrs.version}"
  '';

  meta = {
    description = "The programmer-friendly testing framework for Java and the JVM";
    homepage = "https://junit.org/junit-framework";
    downloadPage = "https://github.com/junit-team/junit-framework";
    changelog = "https://docs.junit.org/${finalAttrs.version}/release-notes";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ airone01 ];
    platforms = lib.platforms.linux;
  };
})
