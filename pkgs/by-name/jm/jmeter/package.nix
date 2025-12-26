{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  gradle,
  jdk17,
  jre,
  makeWrapper,
  coreutils,
  gitMinimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jmeter";
  version = "5.6.3";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "jmeter";
    rev = "rel/v${finalAttrs.version}";
    hash = "sha256-mYjQs32SDoUB6SLXvEVOyxU68b8QRv39XxE3fvn4oNM=";
  };

  patches = [
    # Fix for read-only installations (e.g., Nix store)
    # Ensures directories are writable when generating reports from read-only sources
    # Upstream: https://github.com/apache/jmeter/pull/6358
    (fetchpatch {
      url = "https://github.com/apache/jmeter/commit/f4f1ef144ab5678bddb010ed1f05c67a76f547a5.patch";
      hash = "sha256-ICG2z+nyJT0WDiYmU/Dx3VtkG83ymU7HwYjEuJMjaiY=";
      excludes = [ "xdocs/changes.xml" ];
    })
  ];

  nativeBuildInputs = [
    gradle
    # JMeter's Gradle build-logic uses toolchains that explicitly request Java 17
    jdk17
    makeWrapper
    gitMinimal
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # Required for mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  gradleFlags = [
    # Point Gradle toolchain to the JDK we provide
    "-Dorg.gradle.java.home=${jdk17}"
    # Skip javadoc which tries to fetch external URLs
    "-x"
    "javadocAggregate"
    # Skip checksum verification for dependencies
    # we handle those ourself in `./deps.json`
    "-PchecksumIgnore"
  ];

  # Build the distribution
  gradleBuildTask = ":src:dist:assemble";

  installPhase = ''
    runHook preInstall

    # Extract the built distribution
    # Note: Built distributions have -SNAPSHOT suffix
    mkdir -p $out
    tar -xzf src/dist/build/distributions/apache-jmeter-${finalAttrs.version}-SNAPSHOT.tgz \
      --strip-components=1 -C $out

    # Remove Windows-specific files
    rm -f $out/bin/*.bat $out/bin/*.cmd

    # Fix create-rmi-keystore.sh to use the correct keytool path
    substituteInPlace $out/bin/create-rmi-keystore.sh \
      --replace-fail "keytool -genkey" "${jre}/lib/openjdk/jre/bin/keytool -genkey"

    # Fix mirror-server.sh classpath: discover actual jar names at build time
    # The script has hardcoded jar versions that don't match the built jars
    substituteInPlace $out/bin/mirror-server.sh \
      --replace-fail "oro-2.0.8.jar" "$(basename $out/lib/oro-*.jar)" \
      --replace-fail "slf4j-api-1.7.25.jar" "$(basename $out/lib/slf4j-api-*.jar)" \
      --replace-fail "jcl-over-slf4j-1.7.25.jar" "$(basename $out/lib/jcl-over-slf4j-*.jar)" \
      --replace-fail "log4j-slf4j-impl-2.11.0.jar" "$(basename $out/lib/log4j-slf4j-impl-*.jar)" \
      --replace-fail "log4j-api-2.11.1.jar" "$(basename $out/lib/log4j-api-*.jar)" \
      --replace-fail "log4j-core-2.11.1.jar" "$(basename $out/lib/log4j-core-*.jar)" \
      --replace-fail "log4j-1.2-api-2.11.1.jar" "$(basename $out/lib/log4j-1.2-api-*.jar)"

    # Prefix some scripts with jmeter to avoid clobbering the namespace
    for i in heapdump.sh mirror-server mirror-server.sh shutdown.sh stoptest.sh create-rmi-keystore.sh; do
      mv $out/bin/$i $out/bin/jmeter-$i
      wrapProgram $out/bin/jmeter-$i \
        --prefix PATH : "${jre}/bin"
    done

    wrapProgram $out/bin/jmeter --set JAVA_HOME "${jre}"
    wrapProgram $out/bin/jmeter.sh --set JAVA_HOME "${jre}"

    runHook postInstall
  '';

  nativeCheckInputs = [ coreutils ];

  installCheckPhase = ''
    runHook preInstallCheck

    set -x

    # Test basic functionality
    $out/bin/jmeter --version 2>&1 | grep -q "${finalAttrs.version}"

    # Test helper scripts
    $out/bin/jmeter-heapdump.sh > /dev/null
    $out/bin/jmeter-shutdown.sh > /dev/null
    $out/bin/jmeter-stoptest.sh > /dev/null
    timeout --kill=1s 1s $out/bin/jmeter-mirror-server.sh || test "$?" = "124"

    # Test HTML report generation (regression test for Nix store read-only issue)
    echo "Testing HTML report generation..."

    # Create minimal test results file (using actual JMeter CSV format)
    TMPDIR=$(mktemp -d)
    cat > $TMPDIR/test-results.jtl << 'EOF'
    timeStamp,elapsed,label,responseCode,responseMessage,threadName,dataType,success,failureMessage,bytes,sentBytes,grpThreads,allThreads,URL,Latency,IdleTime,Connect
    1699123200000,100,HTTP Request,200,OK,Thread Group 1-1,text,true,,805,113,1,1,https://example.com/,95,0,25
    1699123201000,150,HTTP Request,200,OK,Thread Group 1-1,text,true,,805,113,1,1,https://example.com/,140,0,30
    1699123202000,200,HTTP Request,500,Internal Server Error,Thread Group 1-1,text,false,Server Error,512,113,1,1,https://example.com/,180,0,40
    EOF

    # Generate HTML report
    echo "Generating HTML report..."
    $out/bin/jmeter -g $TMPDIR/test-results.jtl -o $TMPDIR/test-report 2>/dev/null

    # Verify the report was generated successfully
    echo "Verifying report generation..."
    test -f $TMPDIR/test-report/index.html
    test -f $TMPDIR/test-report/statistics.json
    test -d $TMPDIR/test-report/sbadmin2-1.0.7

    # Verify the HTML contains expected content
    grep -q "Apache JMeter Dashboard" $TMPDIR/test-report/index.html

    # Verify statistics contain the test data
    grep -q "HTTP Request" $TMPDIR/test-report/statistics.json

    echo "HTML report generation test passed!"

    runHook postInstallCheck
  '';

  meta = {
    description = "100% pure Java desktop application designed to load test functional behavior and measure performance";
    longDescription = ''
      The Apache JMeter desktop application is open source software, a 100%
      pure Java application designed to load test functional behavior and
      measure performance. It was originally designed for testing Web
      Applications but has since expanded to other test functions.
    '';
    homepage = "https://jmeter.apache.org/";
    changelog = "https://github.com/apache/jmeter/releases/tag/rel%2Fv${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    platforms = lib.platforms.unix;
    mainProgram = "jmeter";
  };
})
