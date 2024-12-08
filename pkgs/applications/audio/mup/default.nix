{ lib, stdenv, fetchurl, autoreconfHook, bison, flex, ghostscript, groff, netpbm
, fltk, libXinerama, libXpm, libjpeg
}:

stdenv.mkDerivation rec {
  pname = "mup";
  version = "6.8";

  src = fetchurl {
    url = "http://www.arkkra.com/ftp/pub/unix/mup${builtins.replaceStrings ["."] [""] version}src.tar.gz";
    sha256 = "06bv5nyl8rcibyb83zzrfdq6x6f93g3rgnv47i5gsjcaw5w6l31y";
  };

  nativeBuildInputs = [ autoreconfHook bison flex ghostscript groff netpbm ];

  buildInputs = [ fltk libXinerama libXpm libjpeg ];

  patches = [ ./ghostscript-permit-file-write.patch ];

  postPatch = ''
    for f in Makefile.am doc/Makefile.am doc/htmldocs/Makefile.am src/mupmate/Preferences.C; do
      substituteInPlace $f --replace doc/packages doc
    done
    substituteInPlace src/mupprnt/mupprnt --replace 'mup ' $out/bin/mup' '
    substituteInPlace src/mupdisp/genfile.c --replace '"mup"' '"'$out/bin/mup'"'
    substituteInPlace src/mupmate/Preferences.C \
      --replace '"mup"' '"'$out/bin/mup'"' \
      --replace '"gv"' '"xdg-open"' \
      --replace /usr/share/doc $out/share/doc
  '';

  enableParallelBuilding = false; # Undeclared dependencies + https://stackoverflow.com/a/19822767/1687334 for prolog.ps.

  meta = with lib; {
    homepage = "http://www.arkkra.com/";
    description = "Music typesetting program (ASCII to PostScript and MIDI)";
    license = licenses.bsd3;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
