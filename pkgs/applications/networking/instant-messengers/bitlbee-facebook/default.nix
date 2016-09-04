{ fetchurl, fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool, pkgconfig, glib, json_glib }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bitlbee-facebook-2015-08-27";

  src = fetchFromGitHub {
    rev = "094a11b542e2cd8fac4f00fe01870ecd1cb4c062";
    owner = "jgeboski";
    repo = "bitlbee-facebook";
    sha256 = "1dvbl1z6fl3wswvqbs82vkqlggk24dyi8w7cmm5jh1fmaznmwqrl";
  };

  buildInputs = [ bitlbee autoconf automake libtool pkgconfig glib json_glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "The Facebook protocol plugin for bitlbee";

    homepage = https://github.com/jgeboski/bitlbee-facebook;
    license = licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
