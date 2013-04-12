{ stdenv, fetchurl, perl, pkgconfig, glib, ncurses
, enablePlugin ? true }:

let
  basename = "silc-client-1.1.8";
in
stdenv.mkDerivation {
  name = basename + stdenv.lib.optionalString enablePlugin "-irssi-plugin";

  src = fetchurl {
    url = "http://silcnet.org/download/client/sources/${basename}.tar.bz2";
    sha256 = "1qnk35g8sbnfps3bq2k9sy0ymlsijh5n8z59m2ccq4pkmqbfqgv2";
  };

  dontDisableStatic = true;

  patches = [ ./server_setup.patch ];

  preConfigure = stdenv.lib.optionalString enablePlugin ''
    configureFlags="$configureFlags --with-silc-plugin=$out/lib/irssi"
  '';

  buildInputs = [ perl pkgconfig glib ncurses ];

  meta = {
    homepage = http://silcnet.org/;
    description = "Secure Internet Live Conferencing server";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
