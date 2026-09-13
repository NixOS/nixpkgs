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
  version = "5.14.4";

  src = fetchFromGitHub {
    owner = "junit-team";
    repo = "junit5";
    tag = "r${finalAttrs.version}";
    hash = "sha256-Ap2AcpDKLyb4Cckg7luHrIxbEKc2XbtgLytphct47kc=";
    leaveDotGit = true;
  };

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  # Required for mitm-cache to work on Darwin
  __darwinAllowLocalNetworking = true;

  strictDeps = true;

  nativeBuildInputs = [
    gradle
    git
    jdk
  ];

  gradleBuildTask = "assemble";

  # Integration tests require network (Maven/Gradle wrappers): incompatible with sandbox
  doCheck = false;

  gradleFlags = [
    "-Porg.gradle.java.installations.auto-download=false"
    "-Porg.gradle.java.installations.paths=${jdk8.home},${jdk.home}"
    # Disable os-specific native deps to avoid cache miss
    "-Dorg.gradle.native=false"
    # Force ipv4 to avoid Darwin loopback blackholes
    "-Djava.net.preferIPv4Stack=true"
    # Prevent mitm from intercepting local daemon to client traffic
    "-Dhttp.nonProxyHosts=localhost|127.0.0.1"
    # Skip GPG signing — not needed for building jars
    "-Ppublishing.signArtifacts=false"
    # Test fixtures are only needed for JUnit's own test suite, not for the library
    "--exclude-task=testFixturesJar"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java

    # Platform modules use version 1.x.x while Jupiter/Vintage use 5.x.x
    local platformVersion="1''${version#5}"
    find . \( -name "*-$version.jar" -o -name "*-$platformVersion.jar" \) \
      ! -name "*-javadoc.jar" ! -name "*-sources.jar" \
      -exec cp {} $out/share/java/ \;

    runHook postInstall
  '';

  postPatch = ''
    substituteInPlace settings.gradle.kts \
      --replace-fail \
        $'repositories {\n\t\tgradlePluginPortal()\n\t}' \
        $'repositories {\n\t\tgradlePluginPortal()\n\t\tmavenCentral()\n\t}'

    # Clear org.gradle.jvmargs so Gradle does not fork a daemon with different JVM
    # args - the daemon communicates via localhost, which the Darwin sandbox blocks.
    substituteInPlace gradle.properties \
      --replace-fail \
        'org.gradle.jvmargs=-Xmx1g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError' \
        'org.gradle.jvmargs='
  '';

  meta = {
    description = "The programmer-friendly testing framework for Java and the JVM";
    homepage = "https://junit.org/junit-framework";
    downloadPage = "https://github.com/junit-team/junit-framework";
    changelog = "https://docs.junit.org/${finalAttrs.version}/release-notes";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ airone01 ];
    platforms = lib.platforms.all;
  };
})
