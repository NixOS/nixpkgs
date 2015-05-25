{ stdenv, makeWrapper, jdk, mesos, fetchurl }:

stdenv.mkDerivation rec {
  name = "marathon-${version}";
  version = "0.8.2";

  src = fetchurl {
    url = "https://downloads.mesosphere.io/marathon/v${version}/marathon-${version}.tgz";
    sha256 = "9a7ff1a09b395ef676c88282b2e5d2f29f460a0f7ec59b1e4de3290f5ca30e64";
  };

  phases = [ "unpackPhase" "installPhase" ];

  buildInputs = [ makeWrapper jdk mesos ];

  installPhase = ''
    mkdir -p $out/{bin,libexec/marathon}
    cp target/scala-*/marathon*.jar $out/libexec/marathon/${name}.jar

    makeWrapper ${jdk.jre}/bin/java $out/bin/marathon \
      --add-flags "-Xmx512m -jar $out/libexec/marathon/${name}.jar" \
      --prefix "MESOS_NATIVE_JAVA_LIBRARY" : "$MESOS_NATIVE_JAVA_LIBRARY"
    '';

  meta = with stdenv.lib; {
    homepage = https://mesosphere.github.io/marathon;
    description = "Cluster-wide init and control system for services in cgroups or Docker containers";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem ];
    platforms = platforms.linux;
  };
}
