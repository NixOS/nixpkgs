{ stdenv, fetchurl, qmake, qtscript, qtwebkit }:

stdenv.mkDerivation rec {
  version = "18.11.0";
  name = "smtube-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smtube/SMTube/${version}/${name}.tar.bz2";
    sha256 = "0rda7mdsr0awhra9yrmsdzp2c4s6xx5nax107d1fydnk084pygqp";
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
