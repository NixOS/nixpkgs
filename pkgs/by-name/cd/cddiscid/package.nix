{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "cd-discid";
  version = "1.4";

  src = fetchurl {
    url = "http://linukz.org/download/${pname}-${version}.tar.gz";
    sha256 = "0qrcvn7227qaayjcd5rm7z0k5q89qfy5qkdgwr5pd7ih0va8rmpz";
  };

  installFlags = [
    "PREFIX=$(out)"
    "INSTALL=install"
  ];

  meta = with lib; {
    homepage = "http://linukz.org/cd-discid.shtml";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    description = "Command-line utility to get CDDB discid information from a CD-ROM disc";
    mainProgram = "cd-discid";

    longDescription = ''
      cd-discid is a backend utility to get CDDB discid information
      from a CD-ROM disc.  It was originally designed for cdgrab (now
      abcde), but can be used for any purpose requiring CDDB data.
    '';
  };
}
