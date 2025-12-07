{
  lib,
  stdenv,
  makeWrapper,
  python3,
  nixosTests,
  maven,
  fetchFromGitHub,
  jdk,
  graalvmPackages,

  nix-update-script,

  buildNativeImage ? stdenv.hostPlatform.isLinux,
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

  mvnJdk = if buildNativeImage then graalvmPackages.graalvm-ce else jdk;

  mvnHash = "sha256-tlzKHPpd8P5IK1DLrwA6n2noXb6auq6xdUqG/Ri7BQQ=";

  HYDRA_NATIVE_BUILD = "true";

  manualMvnArtifacts = [
    "org.graalvm.buildtools:native-maven-plugin:0.9.27"

    "org.graalvm.buildtools:graalvm-reachability-metadata:0.9.27"

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

  # Broken on JDK 25
  doCheck = !buildNativeImage;

  mvnDepsParameters = projectFilter;
  mvnParameters = projectFilter;

  nativeBuildInputs = [
    makeWrapper
  ];

  postBuild = ''
    mvn ${mvnParameters} -o -nsu "-Dmaven.repo.local=$mvnDeps/.m2" install -DskipTests

    mvn -pl org.nzbhydra:core -o -nsu -Pnative "-Dmaven.repo.local=$mvnDeps/.m2" native:compile -DskipTests
  '';

  installPhase = ''
    runHook preInstall

    ${
      if buildNativeImage then
        ''
          install -d -m 755 "$out/lib/${pname}"
          cp -rt "$out/lib/${pname}" core/target/core core/target/lib*.so
        ''
      else
        ''
          install -d -m 755 "$out/lib/${pname}/lib"
          cp -rt "$out/lib/${pname}/lib" core/target/*-exec.jar
        ''
    }

    touch "$out/lib/${pname}/readme.md"
    install -D -m 755 "other/wrapper/nzbhydra2wrapperPy3.py" "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py"

    makeWrapper ${lib.getExe python3} "$out/bin/nzbhydra2" \
      --add-flags "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py" \
      ${lib.optionalString (!buildNativeImage) "--prefix PATH \":\" ${lib.getBin jdk}/bin"}

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) nzbhydra2;
  };

  passthru.updateScript = nix-update-script { };

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
