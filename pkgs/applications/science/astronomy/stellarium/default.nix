{ mkDerivation, lib, fetchurl
, cmake, freetype, libpng, mesa, gettext, openssl, perl, libiconv
, qtscript, qtserialport, qttools
, qtmultimedia
}:

mkDerivation rec {
  name = "stellarium-${version}";
  version = "0.15.0";

  src = fetchurl {
    url = "mirror://sourceforge/stellarium/${name}.tar.gz";
    sha256 = "0il751lgnfkx35h1m8fzwwnrygpxjx2a80gng1i1rbybkykf7l3l";
  };

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [
    freetype libpng mesa openssl libiconv qtscript qtserialport qttools
    qtmultimedia
  ];

  meta = with lib; {
    description = "Free open-source planetarium";
    homepage = "http://stellarium.org/";
    license = licenses.gpl2;

    platforms = platforms.linux; # should be mesaPlatforms, but we don't have qt on darwin
    maintainers = [ maintainers.peti ];
  };
}
