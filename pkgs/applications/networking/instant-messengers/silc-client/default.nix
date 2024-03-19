{ lib, stdenv, fetchurl, perl, pkg-config, glib, ncurses
, enablePlugin ? false }:

# Enabling the plugin and using it with a recent irssi, segafults on join:
# http://marc.info/?l=silc-devel&m=125610477802211

stdenv.mkDerivation rec {
  pname = "silc-client" + lib.optionalString enablePlugin "-irssi-plugin";
  version = "1.1.11";

  src = fetchurl {
    url = "mirror://sourceforge/silc/silc/client/sources/silc-client-${version}.tar.bz2";
    sha256 = "13cp3fmdnj8scjak0d2xal3bfvs2k7ssrwdhp0zl6jar5rwc7prn";
  };

  enableParallelBuilding = true;

  dontDisableStatic = true;

  hardeningDisable = [ "format" ];

  configureFlags = [ "--with-ncurses=${ncurses.dev}" ];

  preConfigure = lib.optionalString enablePlugin ''
    configureFlags="$configureFlags --with-silc-plugin=$out/lib/irssi"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ perl glib ncurses ];

  meta = {
    homepage = "http://silcnet.org/";
    description = "Secure Internet Live Conferencing server";
    mainProgram = "silc";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}
