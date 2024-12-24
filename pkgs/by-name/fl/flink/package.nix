{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation rec {
  pname = "flink";
  version = "1.20.0";

  src = fetchurl {
    url = "mirror://apache/flink/${pname}-${version}/${pname}-${version}-bin-scala_2.12.tgz";
    sha256 = "sha256-cI/VRMz53cDUsZL+A1eXzhbeLCbx12TFWQcwXv4UCvA=";
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
    env.java.home: ${jre}
    env.log.dir: /tmp/flink-logs
    EOF
  '';

  meta = with lib; {
    description = "Distributed stream processing framework";
    mainProgram = "flink";
    homepage = "https://flink.apache.org";
    downloadPage = "https://flink.apache.org/downloads.html";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    platforms = platforms.all;
    maintainers = with maintainers; [
      mbode
      autophagy
    ];
  };
}
