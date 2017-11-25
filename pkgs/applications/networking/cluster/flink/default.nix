{ stdenv, fetchzip, jre,
  version ? "1.3" }:

let
  versionMap = {
    "1.3" = {
      flinkVersion = "1.3.2";
      scalaVersion = "2.11";
      sha256 = "0dr8c1z4ncza6qp2zcklbmn0gj0l1rics3c8fiminkp8bl454ijg";
    };
  };
in

with versionMap.${version};

stdenv.mkDerivation rec {
  name = "flink-${flinkVersion}";

  src = fetchzip {
    url    = "mirror://apache/flink/${name}/${name}-bin-hadoop27-scala_${scalaVersion}.tgz";
    inherit sha256;
  };

  buildInputs = [ jre ];

  installPhase = ''
    mkdir -p $out
    cp -R bin conf examples lib opt resources $out
    rm $out/bin/*.bat
    chmod +x $out/bin\/*

    cat <<EOF >> $out/conf/flink-conf.yaml
    env.java.home: ${jre}"
    env.log.dir: /tmp/flink-logs
    EOF
  '';

  meta = with stdenv.lib; {
    description      = "An open-source stream processing framework for distributed, high-performing, always-available, and accurate data streaming applications.";
    homepage         = "https://flink.apache.org";
    downloadPage     = "https://flink.apache.org/downloads.html";
    license          = stdenv.lib.licenses.asl20;
    platforms        = stdenv.lib.platforms.all;
    maintainers      = with maintainers; [ mbode ];
    repositories.git = git://git.apache.org/flink.git;
  };
}
