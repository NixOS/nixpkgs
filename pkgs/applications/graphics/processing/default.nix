{ fetchurl, stdenv, ant, jre, makeWrapper, libXxf86vm }:

stdenv.mkDerivation rec {
  name = "processing-${version}";
  version = "2.2.1";

  src = fetchurl {
    url = "https://github.com/processing/processing/archive/processing-0227-${version}.tar.gz";
    sha256 = "1r8q5y0h4gpqap5jwkspc0li6566hzx5chr7hwrdn8mxlzsm50xk";
  };

  # Stop it trying to download its own version of java
  patches = [ ./use-nixpkgs-jre.patch ];

  buildInputs = [ ant jre makeWrapper libXxf86vm ];

  buildPhase = "cd build && ant build";

  installPhase = ''
    mkdir -p $out/bin
    cp -r linux/work/* $out/
    rm $out/processing-java
    sed -e "s#APPDIR=\`dirname \"\$APPDIR\"\`#APPDIR=$out#" -i $out/processing
    mv $out/processing $out/bin/
    wrapProgram $out/bin/processing --prefix PATH : ${jre}/bin --prefix LD_LIBRARY_PATH : ${libXxf86vm}/lib
    mkdir $out/java
    ln -s ${jre}/bin $out/java/
  '';

  meta = with stdenv.lib; {
    description = "A language and IDE for electronic arts";
    homepage = http://processing.org;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
