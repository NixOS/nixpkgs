{ stdenv, fetchurl, makeWrapper, pkgconfig
, gtk, girara, ncurses, gettext, docutils
, file, sqlite, glib, texlive, libintl
, gtk-mac-integration, synctexSupport ? true
}:

assert synctexSupport -> texlive != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name    = "zathura-core-${version}";
  version = "0.3.8";

  src = fetchurl {
    url    = "http://pwmt.org/projects/zathura/download/zathura-${version}.tar.gz";
    sha256 = "0dz5pky3vmf3s2cp2rv1c099gb1s49p9xlgm3ghyy4pzyxc8bgs6";
  };

  icon = ./icon.xpm;

  nativeBuildInputs = [
    pkgconfig libintl
  ];

  buildInputs = [
    file gtk girara
    gettext makeWrapper sqlite glib
  ] ++ optional synctexSupport texlive.bin.core
    ++ optional stdenv.isDarwin [ gtk-mac-integration ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  makeFlags = [
    "PREFIX=$(out)"
    "RSTTOMAN=${docutils}/bin/rst2man.py"
    "VERBOSE=1"
    "TPUT=${ncurses.out}/bin/tput"
    (optionalString synctexSupport "WITH_SYNCTEX=1")
  ];

  postInstall = ''
    wrapProgram "$out/bin/zathura" \
      --prefix PATH ":" "${makeBinPath [ file ]}" \
      --prefix XDG_CONFIG_DIRS ":" "$out/etc"

    install -Dm644 $icon $out/share/pixmaps/pwmt.xpm
    mkdir -pv $out/etc
    echo "set window-icon $out/share/pixmaps/pwmt.xpm" > $out/etc/zathurarc
    echo "Icon=pwmt" >> $out/share/applications/zathura.desktop
  '';

  meta = {
    homepage    = http://pwmt.org/projects/zathura/;
    description = "A core component for zathura PDF viewer";
    license     = licenses.zlib;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ garbas ];
  };
}
