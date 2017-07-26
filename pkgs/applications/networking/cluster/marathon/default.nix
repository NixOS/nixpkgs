{ stdenv, makeWrapper, jdk, mesos, fetchurl }:

stdenv.mkDerivation rec {
  name = "marathon-${version}";
  version = "1.4.2";

  src = fetchurl {
    url = "https://downloads.mesosphere.com/marathon/v${version}/marathon-${version}.tgz";
    sha256 = "6eab65a95c87a989e922aca2b49ba872b50a94e46a8fd4831d1ab41f319d6932";
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
