{
  lib,
  buildPackages,
  cacert,
  fetchFromGitHub,
  jdk11_headless,
  maven,
  nix-update-script,
}:

# This is the library behind the `google-api-client-*.jar` that Gradle bundles
# for `gcs://` repositories and the GCS build cache.
#
# The library trusts only the PKCS12 store bundled in its own jar
# (`GoogleUtils.getCertificateTrustStore()`), not the JDK cacerts. We replace
# it with a store generated from the `cacert` package so that a bumped
# `cacert` rebuilds everything that embeds the store.
#
# The version must match the `google-api-client` version bundled by Gradle,
# see `pkgs/development/tools/build-managers/gradle/default.nix`. The
# updateScript tracks the latest upstream release, so after an update the
# Gradle build fails until the two versions are brought back in lockstep.
maven.buildMavenPackage (finalAttrs: {
  pname = "google-api-java-client";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-api-java-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Iz0ZL9LUp9lOf7RbeyGmAjK2w+isq5ZorjGezk7R6kg=";
  };

  # The build sets -source/-target 1.7. JDK 11 can still compile that,
  # while JDK 20+ cannot.
  mvnJdk = jdk11_headless;

  # Drop the protobuf-maven-plugin: it invokes a protoc binary to generate
  # test-only sources, which we do not build.
  patches = [ ./pom-remove-protobuf-plugin.patch ];

  # Skip compiling and running the tests: `-DskipTests` (what `doCheck =
  # false` does) would still compile them, which needs the protoc binary
  # removed by the patch above, and some of them reach out to the network.
  # The android module is skipped because it depends on
  # com.google.android.google-play-services:1, which was never published to
  # Maven Central (upstream's README asks to install it manually with
  # mvn install:install-file), and the assembly module depends on that
  # android artifact.
  mvnParameters = lib.escapeShellArgs [
    "-Dmaven.test.skip=true"
    "-Dproject.build.outputTimestamp=1980-01-01T00:00:00Z"
    "-pl"
    "!google-api-client-android,!google-api-client-assembly"
  ];

  mvnHash = "sha256-GISmBdRCS2nrKCaFNgWvDfrXUfvNWWHXDxqWhN7sAeU=";

  postPatch = ''
    p12="$(pwd)/google-api-client/src/main/resources/com/google/api/client/googleapis/google.p12"

    # Remove the bundled stores: nothing reads google.jks, and leaving
    # google.p12 in place would make keytool merge our store into it
    # (keeping the outdated upstream roots and the store's legacy
    # encryption parameters).
    rm "$p12" "$(dirname "$p12")/google.jks"

    # The store must keep the original password, "notasecret".
    work="$(mktemp -d)"
    pushd "$work"
    export JAVA_TOOL_OPTIONS="-Dkeystore.pkcs12.certProtectionAlgorithm=NONE -Dkeystore.pkcs12.macAlgorithm=NONE"
    ${buildPackages.jre-generate-cacerts} ${buildPackages.jdk}/bin/keytool ${cacert}/etc/ssl/certs/ca-bundle.crt
    ${buildPackages.jdk}/bin/keytool -importkeystore -noprompt \
      -srckeystore cacerts -srcstorepass changeit \
      -destkeystore "$p12" \
      -deststoretype PKCS12 -deststorepass notasecret
    unset JAVA_TOOL_OPTIONS
    popd
    rm -r "$work"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/java"
    for jar in */target/*.jar; do
      case "$jar" in
        # The sources and javadoc jars would only pollute the CLASSPATH
        # that setJavaClassPath builds from $out/share/java.
        *-sources.jar | *-javadoc.jar | *-tests.jar) continue ;;
      esac
      install -Dm644 "$jar" "$out/share/java/"
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Google APIs Client Library for Java";
    longDescription = ''
      The Google APIs Client Library for Java is a flexible, efficient, and
      powerful Java client library for accessing any HTTP-based API on the
      web, not just Google APIs.
    '';
    homepage = "https://github.com/googleapis/google-api-java-client";
    changelog = "https://github.com/googleapis/google-api-java-client/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.asl20;
    teams = [ lib.teams.java ];
    inherit (jdk11_headless.meta) platforms;
  };
})
