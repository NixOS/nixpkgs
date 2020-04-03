{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "tessera";
  version = "0.10.4";

  src = fetchurl {
    url = "https://oss.sonatype.org/service/local/repositories/releases/content/com/jpmorgan/quorum/${pname}-app/${version}/${pname}-app-${version}-app.jar";
    sha256 = "1sqj0mc80922yavx9hlwnl1kpmavpza2g2aycz1qd0zv0s31z9wj";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/tessera --add-flags "-jar $src"
  '';

  meta = with stdenv.lib; {
    description = "Enterprise Implementation of Quorum's transaction manager";
    homepage = "https://github.com/jpmorganchase/tessera";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut ];
  };
}
