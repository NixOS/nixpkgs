{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  bison,
  flex,
  ghostscript,
  groff,
  netpbm,
  fltk,
  libxinerama,
  libxpm,
  libjpeg,
}:

stdenv.mkDerivation {
  pname = "mup";
  version = "7.2";

  src = fetchurl {
    urls = [
      # Since the original site is geo-blocked in the EU, we may revert to the archived version;
      # please update both URLs during future updates!
      "http://www.arkkra.com/ftp/pub/unix/mup72src.tar.gz"
      "https://web.archive.org/web/20250907143445/http://www.arkkra.com/ftp/pub/unix/mup72src.tar.gz"
    ];
    hash = "sha256-XbfIsSzE7cwdK0DlOyS8PEJbBGc7Doa1HGLsVfx2ZaY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    ghostscript
    groff
    netpbm
  ];

  buildInputs = [
    fltk
    libxinerama
    libxpm
    libjpeg
  ];

  patches = [ ./ghostscript-permit-file-write.patch ];

  postPatch = ''
    for f in Makefile.am doc/Makefile.am doc/htmldocs/Makefile.am src/mupmate/Preferences.C; do
      substituteInPlace $f --replace-fail doc/packages doc
    done
    substituteInPlace src/mupprnt/mupprnt \
      --replace-fail 'mup ' $out/bin/mup' '
    substituteInPlace src/mupdisp/genfile.c \
      --replace-fail '"mup"' '"'$out/bin/mup'"'
    substituteInPlace src/mupmate/Preferences.C \
      --replace-fail '"mup"' '"'$out/bin/mup'"' \
      --replace-fail '"gv"' '"xdg-open"' \
      --replace-fail /usr/share/doc $out/share/doc
  '';

  enableParallelBuilding = false; # Undeclared dependencies + https://stackoverflow.com/a/19822767/1687334 for prolog.ps.

  meta = {
    homepage = "http://www.arkkra.com/";
    description = "Music typesetting program (ASCII to PostScript and MIDI)";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
