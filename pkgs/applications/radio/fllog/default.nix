{ stdenv
, fetchurl
, fltk13
, libjpeg
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "1.2.5";
  pname = "fllog";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${name}.tar.gz";
    sha256 = "042j1g035338vfbl4i9laai8af8iakavar05xn2m4p7ww6x76zzl";
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  meta = {
    description = "Digital modem log program";
    homepage = https://sourceforge.net/projects/fldigi/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ dysinger ];
    platforms = stdenv.lib.platforms.linux;
  };
}
