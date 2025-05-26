{ stdenv, lib, maven, fetchFromGitHub, makeWrapper
, jogl, libXxf86vm, libGL, jre, jdk17 }:

let
  mavenJdk17 = maven.override {
    jdk = jdk17;
  };
in mavenJdk17.buildMavenPackage {
  pname = "osm2world";
  version = "unstable-2024-02-25";

  src = fetchFromGitHub {
    owner = "tordanik";
    repo = "OSM2World";
    rev = "dda165854fb0b5b8c1116afed12703c4ee7f3fdb";
    hash = "sha256-4mwoM3jCwkzlTkvAVJuIAsWgPGBWH25jmFz27oFl/E4=";
  };

  mvnHash = "sha256-caFigTHVMQ/ypKR+0F56gRr+6zOzDCE1loyFpqNBWgw=";
  mvnParameters = "-Dtest=!OverpassReaderTest"; # the test requires Internet connectivity

  buildInputs = lib.optionals stdenv.isLinux [ libXxf86vm ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm644 target/osm2world-*.jar -t $out/share/osm2world
    install -Dm755 target/lib/* -t $out/share/osm2world/lib
  '' + lib.optionalString stdenv.isLinux ''
    # use self-compiled JOGL to avoid patchelf'ing .so inside jars
    rm $out/share/osm2world/lib/{jogl,gluegen,nativewindow}*.jar
    install -Dm755 ${jogl}/share/java/* -t $out/share/osm2world/lib/

    mv $out/share/osm2world/lib/jogl-all.jar $out/share/osm2world/lib/jogl-all-v2.4.0-rc-20210111.jar
    mv $out/share/osm2world/lib/jogl-all-natives-linux-amd64.jar $out/share/osm2world/lib/jogl-all-natives-linux-amd64-v2.4.0-rc-20210111.jar

    mv $out/share/osm2world/lib/gluegen-rt.jar $out/share/osm2world/lib/gluegen-rt-v2.4.0-rc-20210111.jar
    mv $out/share/osm2world/lib/gluegen-rt-natives-linux-amd64.jar $out/share/osm2world/lib/gluegen-rt-natives-linux-amd64-v2.4.0-rc-20210111.jar
  '' + ''
    makeWrapper ${lib.getExe jre} $out/bin/osm2world \
      --add-flags "-Djava.library.path=$out/share/osm2world/lib" \
      ${lib.optionalString stdenv.isLinux "--prefix LD_LIBRARY_PATH : \"${lib.makeLibraryPath [ libGL ]}\""} \
      --add-flags "-Xmx2G --add-exports java.base/java.lang=ALL-UNNAMED --add-exports java.desktop/sun.awt=ALL-UNNAMED --add-exports java.desktop/sun.java2d=ALL-UNNAMED" \
      --add-flags "-jar $out/share/osm2world/osm2world-0.4.0-SNAPSHOT.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "OSM2World is a converter that creates three-dimensional models of the world from OpenStreetMap data.";
    homepage = "https://osm2world.org/";
    changelog = "https://raw.githubusercontent.com/tordanik/OSM2World/master/doc/changes.txt";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ eliandoran ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # dependencies
    ];
    mainProgram = "osm2world";
  };
}
