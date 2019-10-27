{ stdenv, fetchurl, makeWrapper, jre
, version ? "1.6" }:

let
  versionMap = {
    "1.5" = {
      flinkVersion = "1.5.5";
      sha256 = "18wqcqi3gyqd40nspih99gq7ylfs20b35f4dcrspffagwkfp2l4z";
    };
    "1.6" = {
      flinkVersion = "1.9.0";
      sha256 = "1dzfcmqz5j4b545wq2q3xb2xkbhqllr04s3av1afv54y61l5y952";
    };
  };
in

with versionMap.${version};

stdenv.mkDerivation rec {
  name = "flink-${flinkVersion}";

  src = fetchurl {
    url = "mirror://apache/flink/${name}/${name}-bin-scala_2.11.tgz";
    inherit sha256;
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jre ];

  installPhase = ''
    rm bin/*.bat

    mkdir -p $out/bin $out/opt/flink
    mv * $out/opt/flink/
    makeWrapper $out/opt/flink/bin/flink $out/bin/flink \
      --prefix PATH : ${jre}/bin

    cat <<EOF >> $out/opt/flink/conf/flink-conf.yaml
    env.java.home: ${jre}"
    env.log.dir: /tmp/flink-logs
    EOF
  '';

  meta = with stdenv.lib; {
    description = "A distributed stream processing framework";
    homepage = https://flink.apache.org;
    downloadPage = https://flink.apache.org/downloads.html;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ mbode ];
    repositories.git = git://git.apache.org/flink.git;
  };
}
