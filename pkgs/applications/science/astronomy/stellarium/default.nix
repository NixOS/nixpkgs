{stdenv, fetchurl, cmake, freetype, libpng, mesa, gettext, openssl, qt4, perl, libiconv}:

let
  name = "stellarium-0.11.4";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/stellarium/${name}.tar.gz";
    sha256 = "8ad5e9878eb36c2c27f4754dcfc69279123e0eae02cc388074e3cf9b23746535";
  };

  buildInputs = [ cmake freetype libpng mesa gettext openssl qt4 perl libiconv ];

  enableParallelBuilding = true;

  meta = {
    description = "Free open-source planetarium";
    homepage = "http://stellarium.org/";
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux; # should be mesaPlatforms, but we don't have qt on darwin
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
