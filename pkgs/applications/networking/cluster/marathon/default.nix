{ stdenv, makeWrapper, jdk, mesos, fetchurl }:

stdenv.mkDerivation rec {
  name = "marathon-${version}";
  version = "0.15.1";

  src = fetchurl {
    url = "https://downloads.mesosphere.io/marathon/v${version}/marathon-${version}.tgz";
    sha256 = "1ch3nvcwj7pzjjqw4k07gdf7nmdbfkks5j07wl3518bagjqrajj2";
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
    maintainers = with maintainers; [ rushmorem kamilchm ];
    platforms = platforms.linux;
  };
}
