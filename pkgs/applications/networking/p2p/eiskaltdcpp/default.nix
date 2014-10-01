{ stdenv, fetchurl, cmake, pkgconfig, qt4, boost, bzip2, libX11, pcre, libidn, lua5, miniupnpc, aspell, gettext }:

stdenv.mkDerivation rec {
  name = "eiskaltdcpp-2.2.9";

  src = fetchurl {
    url = "https://eiskaltdc.googlecode.com/files/${name}.tar.xz";
    sha256 = "3d9170645450f9cb0a605278b8646fec2110b9637910d86fd27cf245cbe24eaf";
  };

  buildInputs = [ cmake pkgconfig qt4 boost bzip2 libX11 pcre libidn lua5 miniupnpc aspell gettext ];

  cmakeFlags = ''
    -DUSE_ASPELL=ON
    -DUSE_QT_QML=ON
    -DFREE_SPACE_BAR_C=ON
    -DUSE_MINIUPNP=ON
    -DDBUS_NOTIFY=ON
    -DUSE_JS=ON
    -DPERL_REGEX=ON
    -DUSE_CLI_XMLRPC=ON
    -DWITH_SOUNDS=ON
    -DLUA_SCRIPT=ON
    -DWITH_LUASCRIPTS=ON
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A cross-platform program that uses the Direct Connect and ADC protocols";
    homepage = https://code.google.com/p/eiskaltdc/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
