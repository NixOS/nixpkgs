{ fetchurl, stdenv, jre }:

stdenv.mkDerivation rec {
  name = "jmeter-4.0";
  src = fetchurl {
    url = "http://archive.apache.org/dist/jmeter/binaries/apache-${name}.tgz";
    sha256 = "1dvngvi6j8qb6nmf5a3gpi5wxck4xisj41qkrj8sjwb1f8jq6nw4";
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
