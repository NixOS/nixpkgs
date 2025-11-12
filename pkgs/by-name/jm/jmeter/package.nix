{
  fetchurl,
  lib,
  stdenv,
  jre,
  makeWrapper,
  coreutils,
  writeShellScript,
}:

stdenv.mkDerivation rec {
  pname = "jmeter";
  version = "5.6.3";
  src = fetchurl {
    url = "mirror://apache/jmeter/binaries/apache-${pname}-${version}.tgz";
    sha256 = "sha256-9o78F/4GD2mMSKar4lmakzknSGvaKSTb4Ux0iVMY3d4=";
  };

  nativeBuildInputs = [
    makeWrapper
    jre
  ];

  # Wrapper script to handle read-only Nix store files for JMeter report generation
  jmeterWrapper = writeShellScript "jmeter-wrapper" ''
    set -euo pipefail

    # Check if this is a report generation command
    if [[ "$*" == *"-g"* && "$*" == *"-o"* ]]; then
      # Extract the output directory argument
      output_dir=""
      next_is_output=false
      for arg in "$@"; do
        if [[ "$next_is_output" == "true" ]]; then
          output_dir="$arg"
          break
        elif [[ "$arg" == "-o" ]]; then
          next_is_output=true
        fi
      done

      # Create a temporary writable copy for report generation
      if [[ -n "$output_dir" && -d "@out@/bin/report-template" ]]; then
        temp_jmeter_home=$(mktemp -d)
        cp -r "@out@"/* "$temp_jmeter_home/"
        chmod -R u+w "$temp_jmeter_home"

        # Change to temporary directory and run JMeter from there
        # This ensures JMETER_HOME calculation uses the temporary path
        original_dir="$(pwd)"
        cd "$temp_jmeter_home/bin" || exit 1

        # Convert relative paths to absolute paths for JMeter arguments
        args=()
        next_is_output=false
        for arg in "$@"; do
          if [[ "$next_is_output" == "true" ]]; then
            # This is the output directory argument
            if [[ "$arg" != /* ]]; then
              arg="$original_dir/$arg"
            fi
            next_is_output=false
          elif [[ "$arg" == "-o" ]]; then
            next_is_output=true
          elif [[ "$arg" == *.jtl ]] || [[ "$arg" == *.jmx ]] || [[ "$arg" == *.csv ]]; then
            # Convert relative file paths to absolute paths
            if [[ "$arg" != /* ]]; then
              arg="$original_dir/$arg"
            fi
          fi
          args+=("$arg")
        done

        "./..jmeter-wrapped-wrapped" "''${args[@]}"
        exit_code=$?
        cd "$original_dir" || exit 1

        # Cleanup - force removal and ignore errors
        chmod -R u+w "$temp_jmeter_home" 2>/dev/null || true
        rm -rf "$temp_jmeter_home" 2>/dev/null || true

        exit "$exit_code"
      fi
    fi

    # For non-report generation commands, use normal JMeter
    exec "@out@/bin/.jmeter-wrapped" "$@"
  '';

  installPhase = ''
    mkdir $out

    rm bin/*.bat bin/*.cmd

    cp -R * $out/

    # Rename original jmeter to avoid wrapper conflict
    mv $out/bin/jmeter $out/bin/.jmeter-wrapped

    # Install the wrapper script
    substitute ${jmeterWrapper} $out/bin/jmeter \
      --subst-var-by out $out
    chmod +x $out/bin/jmeter

    substituteInPlace $out/bin/create-rmi-keystore.sh --replace \
      "keytool -genkey" \
      "${jre}/lib/openjdk/jre/bin/keytool -genkey"

    # Fix mirror-server.sh classpath: discover actual jar names at build time
    oro_jar=$(basename $(ls $out/lib/oro-*.jar))
    slf4j_api_jar=$(basename $(ls $out/lib/slf4j-api-*.jar))
    jcl_over_slf4j_jar=$(basename $(ls $out/lib/jcl-over-slf4j-*.jar))
    log4j_slf4j_impl_jar=$(basename $(ls $out/lib/log4j-slf4j-impl-*.jar))
    log4j_api_jar=$(basename $(ls $out/lib/log4j-api-*.jar))
    log4j_core_jar=$(basename $(ls $out/lib/log4j-core-*.jar))
    log4j_1_2_api_jar=$(basename $(ls $out/lib/log4j-1.2-api-*.jar))

    substituteInPlace $out/bin/mirror-server.sh \
      --replace "oro-2.0.8.jar" "$oro_jar" \
      --replace "slf4j-api-1.7.25.jar" "$slf4j_api_jar" \
      --replace "jcl-over-slf4j-1.7.25.jar" "$jcl_over_slf4j_jar" \
      --replace "log4j-slf4j-impl-2.11.0.jar" "$log4j_slf4j_impl_jar" \
      --replace "log4j-api-2.11.1.jar" "$log4j_api_jar" \
      --replace "log4j-core-2.11.1.jar" "$log4j_core_jar" \
      --replace "log4j-1.2-api-2.11.1.jar" "$log4j_1_2_api_jar"

    # Prefix some scripts with jmeter to avoid clobbering the namespace
    for i in heapdump.sh mirror-server mirror-server.sh shutdown.sh stoptest.sh create-rmi-keystore.sh; do
      mv $out/bin/$i $out/bin/jmeter-$i
      wrapProgram $out/bin/jmeter-$i \
        --prefix PATH : "${jre}/bin"
    done

    wrapProgram $out/bin/.jmeter-wrapped --set JAVA_HOME "${jre}"
    wrapProgram $out/bin/jmeter.sh --set JAVA_HOME "${jre}"
  '';

  doInstallCheck = true;

  nativeCheckInputs = [ coreutils ];

  installCheckPhase = ''
        # Test basic functionality
        $out/bin/jmeter --version 2>&1 | grep -q "${version}"
        $out/bin/jmeter-heapdump.sh > /dev/null
        $out/bin/jmeter-shutdown.sh > /dev/null
        $out/bin/jmeter-stoptest.sh > /dev/null
        timeout --kill=1s 1s $out/bin/jmeter-mirror-server.sh || test "$?" = "124"

        # Test HTML report generation (regression test for Nix store read-only issue)
        echo "Testing HTML report generation..."

        # Create minimal test results file (using actual JMeter CSV format)
        cat > test-results.jtl << 'EOF'
    timeStamp,elapsed,label,responseCode,responseMessage,threadName,dataType,success,failureMessage,bytes,sentBytes,grpThreads,allThreads,URL,Latency,IdleTime,Connect
    1699123200000,100,HTTP Request,200,OK,Thread Group 1-1,text,true,,805,113,1,1,https://example.com/,95,0,25
    1699123201000,150,HTTP Request,200,OK,Thread Group 1-1,text,true,,805,113,1,1,https://example.com/,140,0,30
    1699123202000,200,HTTP Request,500,Internal Server Error,Thread Group 1-1,text,false,Server Error,512,113,1,1,https://example.com/,180,0,40
    EOF

        # Test HTML report generation (regression test for Nix store read-only issue)
        echo "Generating HTML report..."
        # We test from a temporary directory to ensure we're testing the installed version
        # not the build directory version (which might have writable files)
        cp test-results.jtl /tmp/
        cd /tmp
        $out/bin/jmeter -g test-results.jtl -o test-report 2>/dev/null

        # Verify the report was generated successfully
        echo "Verifying report generation..."
        test -f /tmp/test-report/index.html || (echo "ERROR: index.html not generated" && exit 1)
        test -f /tmp/test-report/statistics.json || (echo "ERROR: statistics.json not generated" && exit 1)
        test -d /tmp/test-report/sbadmin2-1.0.7 || (echo "ERROR: sbladmin2 assets not generated" && exit 1)

        # Verify the HTML contains expected content
        grep -q "Apache JMeter Dashboard" /tmp/test-report/index.html || (echo "ERROR: Invalid HTML content" && exit 1)

        # Verify statistics contain the test data
        grep -q "HTTP Request" /tmp/test-report/statistics.json || (echo "ERROR: Test data not found in statistics" && exit 1)

        echo "HTML report generation test passed!"

        # Cleanup
        rm -rf /tmp/test-results.jtl /tmp/test-report
  '';

  meta = with lib; {
    description = "100% pure Java desktop application designed to load test functional behavior and measure performance";
    longDescription = ''
      The Apache JMeter desktop application is open source software, a 100%
      pure Java application designed to load test functional behavior and
      measure performance. It was originally designed for testing Web
      Applications but has since expanded to other test functions.
    '';
    license = licenses.asl20;
    maintainers = [ ];
    priority = 1;
    platforms = platforms.unix;
  };
}
