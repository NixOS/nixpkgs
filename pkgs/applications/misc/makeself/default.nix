{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "makeself-2.2.0";
  src = fetchgit {
    url = "https://github.com/megastep/makeself.git";
    rev = "b836b9281ae99abe1865608b065551da56c80719";
    sha256 = "f7c97f0f8ad8128f2f1b54383319f2cc44cbb05b60ced222784debdf326f23ad";
  };
  installPhase = ''
    mkdir -p $out/{bin,share/{${name},man/man1}}
    mv makeself.lsm README.md $out/share/${name}
    mv makeself.sh $out/bin/makeself
    mv makeself.1  $out/share/man/man1/
    mv makeself-header.sh $out/share/${name}
    sed -e 's|HEADER=`dirname $0`/makeself-header.sh|HEADER=`dirname $0`/../share/${name}/makeself-header.sh|' -i $out/bin/makeself
  '';
  meta = with stdenv.lib; {
    homepage = http://megastep.org/makeself;
    description = "Utility to create self-extracting packages";
    license = licenses.gpl2;
    maintainers = [ maintainers.wmertens ];
    platforms = platforms.all;
  };
}
