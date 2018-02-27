{ stdenv, fetchurl, makeWrapper, jre
, version ? "1.3" }:

let
  versionMap = {
    "1.3" = {
      flinkVersion = "1.3.2";
      scalaVersion = "2.11";
      sha256 = "0mf4qz0963bflzidgslvwpdlvj9za9sj20dfybplw9lhd4sf52rp";
      hadoopBundle = "-hadoop27";
    };
    "1.4" = {
      flinkVersion = "1.4.0";
      scalaVersion = "2.11";
      sha256 = "0d80djx1im3h8mf60qzi12km1bbik8a5l3nks85jzi0r0xzfgkm6";
      hadoopBundle = "";
    };
  };
in

with versionMap.${version};

stdenv.mkDerivation rec {
  name = "flink-${flinkVersion}";

  src = fetchurl {
    url = "mirror://apache/flink/${name}/${name}-bin${hadoopBundle}-scala_${scalaVersion}.tgz";
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
