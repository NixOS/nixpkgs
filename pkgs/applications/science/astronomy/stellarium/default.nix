{ mkDerivation, lib, fetchurl
, cmake, freetype, libpng, libGLU_combined, gettext, openssl, perl, libiconv
, qtscript, qtserialport, qttools
, qtmultimedia, qtlocation
}:

mkDerivation rec {
  name = "stellarium-${version}";
  version = "0.16.1";

  src = fetchurl {
    url = "mirror://sourceforge/stellarium/${name}.tar.gz";
    sha256 = "087x6mbcn2yj8d3qi382vfkzgdwmanxzqi5l1x3iranxmx9c40dh";
  };

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [
    freetype libpng libGLU_combined openssl libiconv qtscript qtserialport qttools
    qtmultimedia qtlocation
  ];

  meta = with lib; {
    description = "Free open-source planetarium";
    homepage = http://stellarium.org/;
    license = licenses.gpl2;

    platforms = platforms.linux; # should be mesaPlatforms, but we don't have qt on darwin
    maintainers = with maintainers; [ peti ma27 ];
  };
}
