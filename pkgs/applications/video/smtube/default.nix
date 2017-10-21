{ stdenv, fetchurl, qmake, qtscript, qtwebkit }:

stdenv.mkDerivation rec {
  version = "17.5.0";
  name = "smtube-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smtube/SMTube/${version}/${name}.tar.bz2";
    sha256 = "13m0ll18n1da8i4r4b7gn0jjz9dgrkkyk9mpfas4rgnjw92m5jld";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  dontUseQmakeConfigure = true;

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtscript qtwebkit ];

  meta = with stdenv.lib; {
    description = "Play and download Youtube videos";
    homepage = http://smplayer.sourceforge.net/smtube.php;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.linux;
  };
}
