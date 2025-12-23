{
  lib,
  makeWrapper,
  python3,
  nixosTests,
  maven,
  fetchFromGitHub,
  jdk,
}:

# Skip some plugins not required for NixOS packaging to reduce required dependencies.
# Also skip the integration tests because they don't work in the sandbox.
let
  projectFilter = "--projects ${
    lib.concatMapStringsSep "," (x: "!org.nzbhydra:${x}") [
      "github-release-plugin"
      "discordreleaser"
      "releases"
      "generic-release"
      "linux-amd64-release"
      "linux-arm64-release"
      "windows-release"
      "tests"
    ]
  },!org.nzbhydra.tests:system";
in
maven.buildMavenPackage rec {
  pname = "nzbhydra2";
  version = "8.1.2";

  src = fetchFromGitHub {
    owner = "theotherp";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-BD9bvbPaVz3MJam78EHqfFc9jbh1SpkIxTe0UK8Lh0w=";
  };

  patches = [
    # Older lombok versions are incompatible with newer JDK versions.
    ./lombok-compiler-annotation.patch
  ];

  buildOffline = true;

  mvnJdk = jdk;

  mvnHash = "sha256-SXanl43Fpd7IdhuD1H2LpB5BwvzbbjRNyZYzBvV1XXY=";

  manualMvnArtifacts = [
    "org.springframework.boot:spring-boot-maven-plugin:4.0.0"

    "org.apache.maven.plugins:maven-antrun-plugin:3.1.0"
    "org.apache.maven.plugins:maven-dependency-plugin:3.7.0"
    "org.apache.maven.plugins:maven-release-plugin:3.0.1"
    "org.apache.maven.plugins:maven-plugin-plugin:3.7.1"
    "org.apache.maven.plugins:maven-install-plugin:3.1.4"

    # Dependencies for building and running tests are included below.
    # The set of dependencies for successfully building and running the tests is different.
    # For simplicity all dependencies are included here, independently of whether we're running the tests.
    "org.apache.maven.plugins:maven-surefire-plugin:2.22.2"
    "org.apache.maven.surefire:surefire-junit4:3.0.0-M2"
    "org.apache.maven.surefire:surefire-junit-platform:2.22.2"
    "org.apache.maven.surefire:surefire-junit-platform:3.0.0-M2"
    "org.apache.maven.surefire:surefire-junit-platform:3.2.5"
    "org.junit.platform:junit-platform-surefire-provider:1.3.2"
  ];

  doCheck = true;

  mvnDepsParameters = projectFilter;
  mvnParameters = projectFilter;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -d -m 755 "$out/lib/${pname}/lib"
    cp -rt "$out/lib/${pname}/lib" core/target/*-exec.jar
    touch "$out/lib/${pname}/readme.md"
    install -D -m 755 "other/wrapper/nzbhydra2wrapperPy3.py" "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py"

    makeWrapper ${lib.getExe python3} "$out/bin/nzbhydra2" \
      --add-flags "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py" \
      --prefix PATH ":" ${lib.getBin jdk}/bin

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) nzbhydra2;
  };

  meta = {
    description = "Usenet meta search";
    homepage = "https://github.com/theotherp/nzbhydra2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      matteopacini
      tmarkus
    ];
    platforms = lib.platforms.linux;
    mainProgram = "nzbhydra2";
  };
}
