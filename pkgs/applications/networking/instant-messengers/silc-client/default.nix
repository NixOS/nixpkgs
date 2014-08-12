{ stdenv, fetchurl, perl, pkgconfig, glib, ncurses
, enablePlugin ? false }:

# Enabling the plugin and using it with a recent irssi, segafults on join:
# http://marc.info/?l=silc-devel&m=125610477802211

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

  configureFlags = "--with-ncurses=${ncurses}";

  preConfigure = stdenv.lib.optionalString enablePlugin ''
    configureFlags="$configureFlags --with-silc-plugin=$out/lib/irssi"
  '';

  buildInputs = [ perl pkgconfig glib ncurses ];

  meta = {
    homepage = http://silcnet.org/;
    description = "Secure Internet Live Conferencing server";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
