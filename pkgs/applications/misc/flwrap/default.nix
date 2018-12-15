{ stdenv
, fetchurl
, fltk13
, libjpeg
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "1.3.5";
  pname = "flwrap";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${name}.tar.gz";
    sha256 = "0qqivqkkravcg7j45740xfky2q3k7czqpkj6y364qff424q2pppg";
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  meta = {
    description = "Digital modem file transfer program";
    homepage = https://sourceforge.net/projects/fldigi/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ dysinger ];
    platforms = stdenv.lib.platforms.linux;
  };
}
