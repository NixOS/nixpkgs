{ stdenv, lib, fetchurl, pkgconfig, gtk, girara, ncurses, gettext, docutils, file, makeWrapper, zathura_icon, sqlite, glib
, synctexSupport ? true, texlive ? null
}:

assert synctexSupport -> texlive != null;

stdenv.mkDerivation rec {
  version = "0.3.6";
  name = "zathura-core-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/download/zathura-${version}.tar.gz";
    sha256 = "0fyb5hak0knqvg90rmdavwcmilhnrwgg1s5ykx9wd3skbpi8nsh8";
  };

  buildInputs = [ pkgconfig file gtk girara gettext makeWrapper sqlite glib
  ] ++ lib.optional synctexSupport texlive.bin.core;

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  makeFlags = [
    "PREFIX=$(out)"
    "RSTTOMAN=${docutils}/bin/rst2man.py"
    "VERBOSE=1"
    "TPUT=${ncurses.out}/bin/tput"
  ] ++ lib.optional synctexSupport "WITH_SYNCTEX=1";

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
