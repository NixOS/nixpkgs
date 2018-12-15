{ stdenv
, fetchurl
, fltk13
, libjpeg
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "4.0.7";
  pname = "flmsg";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${name}.tar.gz";
    sha256 = "1kdlwhxsw02pas9d0kakkq2713wj1m4q881f6am5aq4x8n01f4xw";
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  meta = {
    description = "Digital modem message program";
    homepage = https://sourceforge.net/projects/fldigi/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ dysinger ];
    platforms = stdenv.lib.platforms.linux;
  };
}
