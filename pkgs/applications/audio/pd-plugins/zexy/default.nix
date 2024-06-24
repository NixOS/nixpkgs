{ lib, stdenv, fetchurl, autoconf, automake, puredata }:

stdenv.mkDerivation rec {
  pname = "zexy";
  version = "2.2.4";

  src = fetchurl {
    url = "https://puredata.info/downloads/zexy/releases/${version}/${pname}-${version}.tar.gz";
    sha256 = "1xpgl82c2lc6zfswjsa7z10yhv5jb7a4znzh3nc7ffrzm1z8vylp";
  };

  nativeBuildInputs = [ autoconf automake  ];
  buildInputs = [ puredata ];

  preBuild = ''
    export LD=$CXX
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
    description = "Swiss army knife for puredata";
    homepage = "http://puredata.info/downloads/zexy";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
