{ stdenv, makeWrapper, jdk, mesos, fetchurl }:

stdenv.mkDerivation rec {
  name = "marathon-${version}";
  version = "1.4.1";

  src = fetchurl {
    url = "https://downloads.mesosphere.com/marathon/v${version}/marathon-${version}.tgz";
    sha256 = "1wpzsvvmk19qrwzwj7k12rngry1qriiqnjzq2q2pbpv5w0zb1fz5";
  };

  buildInputs = [ makeWrapper jdk mesos ];

  installPhase = ''
    mkdir -p $out/{bin,libexec/marathon}
    cp target/scala-*/marathon*.jar $out/libexec/marathon/${name}.jar

    makeWrapper ${jdk.jre}/bin/java $out/bin/marathon \
      --add-flags "-Xmx512m -jar $out/libexec/marathon/${name}.jar" \
      --set "MESOS_NATIVE_JAVA_LIBRARY" "$MESOS_NATIVE_JAVA_LIBRARY"
    '';

  meta = with stdenv.lib; {
    homepage = https://mesosphere.github.io/marathon;
    description = "Cluster-wide init and control system for services in cgroups or Docker containers";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem kamilchm kevincox pradeepchhetri ];
    platforms = platforms.linux;
  };
}
