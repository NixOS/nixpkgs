{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "ftop";
  version = "1.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ftop/${pname}-${version}.tar.bz2";
    sha256 = "3a705f4f291384344cd32c3dd5f5f6a7cd7cea7624c83cb7e923966dbcd47f82";
  };

  buildInputs = [ ncurses ];

  patches = [
    ./ftop-fix_buffer_overflow.patch
    ./ftop-fix_printf_format.patch
  ];
  patchFlags = [ "-p0" ];

  postPatch = ''
    substituteInPlace configure --replace "curses" "ncurses"
  '';

  meta = with lib; {
    description = "Show progress of open files and file systems";
    mainProgram = "ftop";
    homepage = "https://code.google.com/archive/p/ftop/";
    license = licenses.gpl3Plus;
    longDescription = ''
      ftop is to files what top is to processes. The progress of all open files
      and file systems can be monitored. If run as a regular user, the set of
      open files will be limited to those in that user's processes (which is
      generally all that is of interest to the user).
      As with top, the items are displayed in order from most to least active.
    '';
    platforms = platforms.linux;
  };
}
