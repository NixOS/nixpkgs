{ stdenv, lib, fetchurl, pkgconfig, gtk, girara, ncurses, gettext, docutils
, file, makeWrapper, sqlite, glib
, synctexSupport ? true, texlive ? null }:

assert synctexSupport -> texlive != null;

stdenv.mkDerivation rec {
  version = "0.3.6";
  name = "zathura-core-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/download/zathura-${version}.tar.gz";
    sha256 = "0fyb5hak0knqvg90rmdavwcmilhnrwgg1s5ykx9wd3skbpi8nsh8";
  };

  icon = ./icon.xpm;

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
      --prefix PATH ":" "${lib.makeBinPath [ file ]}" \
      --prefix XDG_CONFIG_DIRS ":" "$out/etc"

    install -Dm644 $icon $out/share/pixmaps/pwmt.xpm
    mkdir -pv $out/etc
    echo "set window-icon $out/share/pixmaps/pwmt.xpm" > $out/etc/zathurarc
    echo "Icon=pwmt" >> $out/share/applications/zathura.desktop
  '';

  meta = with stdenv.lib; {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A core component for zathura PDF viewer";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ garbas ];
  };
}
