{ stdenv, fetchurl, makeWrapper, jre
, version ? "1.5" }:

let
  versionMap = {
    "1.3" = {
      flinkVersion = "1.3.3";
      scalaVersion = "2.11";
      sha256 = "0gfm48k5adr14gnhqri9cd01i9dprd0nwmnnz3yrpd20nq4ap4qy";
      hadoopBundle = "-hadoop27";
    };
    "1.4" = {
      flinkVersion = "1.4.2";
      scalaVersion = "2.11";
      sha256 = "0x3cikys5brin0kx9zr69xfp8k5w6g8141yrrr26ks7gpss2x636";
      hadoopBundle = "";
    };
    "1.5" = {
      flinkVersion = "1.5.0";
      scalaVersion = "2.11";
      sha256 = "0n5023dj8ivmbhqxmb3abmfh3ahb9vmcywq5i0ll5p7xxcw2c1cv";
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
