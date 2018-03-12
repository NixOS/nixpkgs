{ fetchurl, stdenv, ant, jdk, makeWrapper, libXxf86vm, which }:

stdenv.mkDerivation rec {
  name = "processing-${version}";
  rev = "0263";
  version = "3.3.6";

  src = fetchurl {
    url = "https://github.com/processing/processing/archive/processing-${rev}-${version}.tar.gz";
    sha256 = "0y5ib4yp429dx9ira3knhv4209a74sjncciwrngdblk9j7in30wl";
  };

  # Stop it trying to download its own version of java
  patches = [ ./use-nixpkgs-jre.patch ];

  buildInputs = [ ant jdk makeWrapper libXxf86vm which ];

  buildPhase = "cd build && ant build";

  installPhase = ''
    mkdir -p $out/${name}
    mkdir -p $out/bin
   cp -r linux/work/* $out/${name}/
   makeWrapper $out/${name}/processing $out/bin/processing \
     --prefix PATH : "${stdenv.lib.makeBinPath [ jdk which ]}" \
     --prefix LD_LIBRARY_PATH : ${libXxf86vm}/lib
   makeWrapper $out/${name}/processing-java $out/bin/processing-java \
     --prefix PATH : "${stdenv.lib.makeBinPath [ jdk which ]}" \
     --prefix LD_LIBRARY_PATH : ${libXxf86vm}/lib
   ln -s ${jdk} $out/${name}/java
  '';

  meta = with stdenv.lib; {
    description = "A language and IDE for electronic arts";
    homepage = https://processing.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
