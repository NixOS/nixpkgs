{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "flink";
  version = "1.14.4";

  src = fetchurl {
    url = "mirror://apache/flink/${pname}-${version}/${pname}-${version}-bin-scala_2.11.tgz";
    sha256 = "sha256-qvWUh+EQT/MljN5LCX2JLMEapIEGAbAljrCMTYsFqtw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jre ];

  installPhase = ''
    rm bin/*.bat || true

    mkdir -p $out/bin $out/opt/flink
    mv * $out/opt/flink/
    makeWrapper $out/opt/flink/bin/flink $out/bin/flink \
      --prefix PATH : ${jre}/bin

    cat <<EOF >> $out/opt/flink/conf/flink-conf.yaml
    env.java.home: ${jre}"
    env.log.dir: /tmp/flink-logs
    EOF
  '';

  meta = with lib; {
    description = "A distributed stream processing framework";
    homepage = "https://flink.apache.org";
    downloadPage = "https://flink.apache.org/downloads.html";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ mbode ];
  };
}
