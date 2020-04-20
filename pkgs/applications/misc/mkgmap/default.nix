{ stdenv, fetchurl, fetchsvn, jdk, jre, ant, makeWrapper }:

let
  fastutil = fetchurl {
    url = "http://ivy.mkgmap.org.uk/repo/it.unimi.dsi/fastutil/6.5.15-mkg.1b/jars/fastutil.jar";
    sha256 = "0d88m0rpi69wgxhnj5zh924q4zsvxq8m4ybk7m9mr3gz1hx0yx8c";
  };
  osmpbf = fetchurl {
    url = "http://ivy.mkgmap.org.uk/repo/crosby/osmpbf/1.3.3/jars/osmpbf.jar";
    sha256 = "0zb4pqkwly5z30ww66qhhasdhdrzwmrw00347yrbgyk2ii4wjad3";
  };
  protobuf = fetchurl {
    url = "https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/2.5.0/protobuf-java-2.5.0.jar";
    sha256 = "0x6c4pbsizvk3lm6nxcgi1g2iqgrxcna1ip74lbn01f0fm2wdhg0";
  };
in

stdenv.mkDerivation rec {
  pname = "mkgmap";
  version = "4432";

  src = fetchsvn {
    url = "https://svn.mkgmap.org.uk/mkgmap/mkgmap/trunk";
    rev = version;
    sha256 = "1z1ppf9v1b9clnx20v15xkmdrfw6q4h7i15drzxsdh2wl6bafzvx";
  };

  # This patch removes from the build process
  # the automatic download of dependencies (see configurePhase)
  patches = [ ./build.xml.patch ];

  nativeBuildInputs = [ jdk ant makeWrapper ];

  configurePhase = ''
    mkdir -p lib/compile
    cp ${fastutil} ${osmpbf} ${protobuf} lib/compile/
  '';

  buildPhase = "ant";

  installPhase = ''
    cd dist
    install -Dm644 mkgmap.jar $out/share/java/mkgmap/mkgmap.jar
    install -Dm644 doc/mkgmap.1 $out/share/man/man1/mkgmap.1
    cp -r lib/ $out/share/java/mkgmap/
    makeWrapper ${jre}/bin/java $out/bin/mkgmap \
      --add-flags "-jar $out/share/java/mkgmap/mkgmap.jar"
  '';

  meta = with stdenv.lib; {
    description = "Create maps for Garmin GPS devices from OpenStreetMap (OSM) data";
    homepage = "http://www.mkgmap.org.uk";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
  };
}
