{ stdenv, makeWrapper, jdk, mesos, fetchurl }:

stdenv.mkDerivation rec {
  name = "marathon-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "https://downloads.mesosphere.io/marathon/v${version}/marathon-${version}.tgz";
    sha256 = "1g2z2c8p47rryyappwv0k3najb6bypvwgg7z9z8prvph2x6rafp6";
  };

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
