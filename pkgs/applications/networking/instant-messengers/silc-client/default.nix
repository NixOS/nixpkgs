{ stdenv, fetchurl, perl, pkgconfig, glib, ncurses
, enablePlugin ? false }:

# Enabling the plugin and using it with a recent irssi, segafults on join:
# http://marc.info/?l=silc-devel&m=125610477802211

let
  basename = "silc-client-1.1.11";
in
stdenv.mkDerivation {
  name = basename + stdenv.lib.optionalString enablePlugin "-irssi-plugin";

  src = fetchurl {
    url = "mirror://sourceforge/silc/silc/client/sources/${basename}.tar.bz2";
    sha256 = "13cp3fmdnj8scjak0d2xal3bfvs2k7ssrwdhp0zl6jar5rwc7prn";
  };

  enableParallelBuilding = true;

  dontDisableStatic = true;

  hardeningDisable = [ "format" ];

  configureFlags = "--with-ncurses=${ncurses.dev}";

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
