{ stdenv
, fetchurl
, fltk13
, libjpeg
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "1.3.41";
  pname = "flrig";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${name}.tar.gz";
    sha256 = "0vh14azg3pppyg3fb7kf6q3ighw1ka9m60jf2dzsd77f4hidhqx4";
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  meta = {
    description = "Digital modem rig control program";
    homepage = https://sourceforge.net/projects/fldigi/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ dysinger ];
    platforms = stdenv.lib.platforms.linux;
  };
}
