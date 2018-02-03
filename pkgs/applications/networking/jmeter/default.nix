{ fetchurl, stdenv, jre }:

stdenv.mkDerivation rec {
  name = "jmeter-3.3";
  src = fetchurl {
    url = "http://archive.apache.org/dist/jmeter/binaries/apache-${name}.tgz";
    sha256 = "190k6yrh5casadphkv4azp4nvf4wf2q85mrfysw67r9d96nb9kk5";
  };

  buildInputs = [ jre ];

  installPhase = ''
    substituteInPlace ./bin/jmeter.sh --replace "java $ARGS" "${jre}/bin/java $ARGS"
    substituteInPlace ./bin/jmeter --replace "java $ARGS" "${jre}/bin/java $ARGS"
    mkdir $out
    cp ./* $out/ -R
  '';

  meta = {
    description = "A 100% pure Java desktop application designed to load test functional behavior and measure performance";
    longDescription = ''
      The Apache JMeter desktop application is open source software, a 100%
      pure Java application designed to load test functional behavior and
      measure performance. It was originally designed for testing Web
      Applications but has since expanded to other test functions.
    '';
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    priority = 1;
    platforms = stdenv.lib.platforms.unix;
  };
}
