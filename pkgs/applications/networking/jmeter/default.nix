{ fetchurl, stdenv, ant }:

stdenv.mkDerivation rec {
  name = "jmeter-2.9";
  src = fetchurl {
    url = "http://ftp.unicamp.br/pub/apache//jmeter/binaries/apache-jmeter-2.9.tgz";
    sha256 = "14r3zn910m97jqrf6k5c4lwy214snaap2242qg76h65zk9qr20ni";
  };

  installPhase = ''
    mkdir $out
    cp ./* $out/ -R
  '';

  meta = {
    description = "Apache JMeter is a 100% pure Java desktop application designed to load test functional behavior and measure performance.";
    longDescription = ''
      The Apache JMeter desktop application is open source software, a 100%
      pure Java application designed to load test functional behavior and
      measure performance. It was originally designed for testing Web
      Applications but has since expanded to other test functions.
    '';
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    priority = 1;
  };
}
