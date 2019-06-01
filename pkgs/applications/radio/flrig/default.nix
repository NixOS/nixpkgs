{ stdenv
, fetchurl
, fltk13
, libjpeg
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "1.3.44";
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "0y05qhjmqydh0lripb44jjkcchxzr8bfn1r2k3m48wb4aij607yj";
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
