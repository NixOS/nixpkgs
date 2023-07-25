{ fetchurl, lib, stdenv, jre, makeWrapper, coreutils }:

stdenv.mkDerivation rec {
  pname = "jmeter";
  version = "5.6";
  src = fetchurl {
    url = "https://archive.apache.org/dist/jmeter/binaries/apache-${pname}-${version}.tgz";
    sha256 = "sha256-AZaQ4vNSB3418fJxXLPAX472lnsyBMCYBltdFqwSP54=";
  };

  nativeBuildInputs = [ makeWrapper jre ];

  installPhase = ''
    mkdir $out

    rm bin/*.bat bin/*.cmd

    cp -R * $out/

    substituteInPlace $out/bin/create-rmi-keystore.sh --replace \
      "keytool -genkey" \
      "${jre}/lib/openjdk/jre/bin/keytool -genkey"

    # Prefix some scripts with jmeter to avoid clobbering the namespace
    for i in heapdump.sh mirror-server mirror-server.sh shutdown.sh stoptest.sh create-rmi-keystore.sh; do
      mv $out/bin/$i $out/bin/jmeter-$i
      wrapProgram $out/bin/jmeter-$i \
        --prefix PATH : "${jre}/bin"
    done

    wrapProgram $out/bin/jmeter --set JAVA_HOME "${jre}"
    wrapProgram $out/bin/jmeter.sh --set JAVA_HOME "${jre}"
  '';

  doInstallCheck = false; #NoClassDefFoundError: org/apache/logging/log4j/Level for tests

  nativeCheckInputs = [ coreutils ];

  installCheckPhase = ''
    $out/bin/jmeter --version 2>&1 | grep -q "${version}"
    $out/bin/jmeter-heapdump.sh > /dev/null
    $out/bin/jmeter-shutdown.sh > /dev/null
    $out/bin/jmeter-stoptest.sh > /dev/null
    timeout --kill=1s 1s $out/bin/jmeter-mirror-server.sh || test "$?" = "124"
  '';

  meta = with lib; {
    description = "A 100% pure Java desktop application designed to load test functional behavior and measure performance";
    longDescription = ''
      The Apache JMeter desktop application is open source software, a 100%
      pure Java application designed to load test functional behavior and
      measure performance. It was originally designed for testing Web
      Applications but has since expanded to other test functions.
    '';
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
    priority = 1;
    platforms = platforms.unix;
  };
}
