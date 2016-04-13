{ stdenv, fetchurl, pkgconfig, gtk, girara, ncurses, gettext, docutils, file, makeWrapper, zathura_icon, sqlite, glib }:

stdenv.mkDerivation rec {
  version = "0.3.5";
  name = "zathura-core-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/download/zathura-${version}.tar.gz";
    sha256 = "031kdr10065q14nixc4p58c4rgvrqcmn9x39b19h2357kzabaw9a";
  };

  buildInputs = [ pkgconfig file gtk girara gettext makeWrapper sqlite glib ];

  NIX_CFLAGS_COMPILE = "-I${glib}/include/gio-unix-2.0";

  makeFlags = [
    "PREFIX=$(out)"
    "RSTTOMAN=${docutils}/bin/rst2man.py"
    "VERBOSE=1"
    "TPUT=${ncurses.out}/bin/tput"
  ];

  postInstall = ''
    wrapProgram "$out/bin/zathura" \
      --prefix PATH ":" "${file}/bin" \
      --prefix XDG_CONFIG_DIRS ":" "$out/etc"

    mkdir -pv $out/etc
    echo "set window-icon ${zathura_icon}" > $out/etc/zathurarc
  '';

  meta = {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A core component for zathura PDF viewer";
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.garbas ];

    # Set lower priority in order to provide user with a wrapper script called
    # 'zathura' instead of real zathura executable. The wrapper will build
    # plugin path argument before executing the original.
    priority = 1;
  };
}
