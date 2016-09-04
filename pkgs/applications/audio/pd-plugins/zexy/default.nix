{ stdenv, fetchurl, autoconf, automake, puredata }:

stdenv.mkDerivation rec {
  name = "zexy-${version}";
  version = "2.2.4";

  src = fetchurl {
    url = "http://puredata.info/downloads/zexy/releases/${version}/${name}.tar.gz";
    sha256 = "1xpgl82c2lc6zfswjsa7z10yhv5jb7a4znzh3nc7ffrzm1z8vylp";
  };

  buildInputs = [ autoconf automake puredata ];

  patchPhase = ''
    cd src/
    for i in ${puredata}/include/pd/*; do
      ln -s $i .
    done
    ./bootstrap.sh
    ./configure --enable-lpt=no --prefix=$out
  '';

  postInstall = ''
    mv $out/lib/pd/extra/zexy $out
    rm -rf $out/lib
  '';

  meta = {
    description = "The swiss army knife for puredata";
    homepage = http://puredata.info/downloads/zexy;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
