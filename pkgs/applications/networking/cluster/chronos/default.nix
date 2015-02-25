{ stdenv, lib, makeWrapper, fetchgit, curl, jdk, maven, nodejs, mesos }:

stdenv.mkDerivation rec {
  name = "chronos-${version}";
  version = "286b2ccb8e4695f8e413406ceca85b60d3a87e22";

  src = fetchgit {
    url = "https://github.com/airbnb/chronos";
    rev = version;
    sha256 = "6c463c30530dc82276d30087e7ab08d6964b884232c0a93f691cef9fa1ff2651";
  };

  buildInputs = [ makeWrapper curl jdk maven nodejs mesos ];

  mavenRepo = import ./chronos-deps.nix { inherit stdenv curl; };

  buildPhase = ''
    ln -s $mavenRepo .m2
    mvn package -Dmaven.repo.local=$(pwd)/.m2
  '';

  installPhase = ''
    mkdir -p $out/{bin,libexec/chronos}
    cp target/chronos*.jar $out/libexec/chronos/${name}.jar

    makeWrapper ${jdk.jre}/bin/java $out/bin/chronos \
      --add-flags "-Xmx384m -Xms384m -cp $out/libexec/chronos/${name}.jar com.airbnb.scheduler.Main" \
      --prefix "MESOS_NATIVE_LIBRARY" : "$MESOS_NATIVE_LIBRARY"
  '';

  meta = with lib; {
    homepage    = http://airbnb.github.io/chronos;
    license     = licenses.asl20;
    description = "Fault tolerant job scheduler for Mesos which handles dependencies and ISO8601 based schedules";
    maintainers = with maintainers; [ offline ];
    platforms   = with platforms; unix;
  };
}
