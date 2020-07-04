{ stdenv
, fetchurl
, pkg-config
, autoconf
, gtk2
, alsaLib
, SDL
, jack2
, goocanvas # graphical envelope editing
}:

stdenv.mkDerivation rec {
  pname = "soundtracker";
  version = "1.0.0.1";

  src = fetchurl {
    # Past releases get moved to the "old releases" directory.
    # Only the latest release (currently a prerelease) is at the top level.
    url = "mirror://sourceforge/soundtracker/old%20releases/soundtracker-${version}.tar.bz2";
    sha256 = "1ggliswz5ngmlnrnyhv3x1arh5w77an0ww9p53cddp9aas5q11jm";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
  ];
  buildInputs = [
    gtk2
    SDL
    jack2
    goocanvas
  ] ++ stdenv.lib.optional stdenv.isLinux alsaLib;

  meta = with stdenv.lib; {
    description = "A music tracking tool similar in design to the DOS program FastTracker and the Amiga legend ProTracker";
    longDescription = ''
      SoundTracker is a pattern-oriented music editor (similar to the DOS
      program 'FastTracker'). Samples are lined up on tracks and patterns
      which are then arranged to a song. Supported module formats are XM and
      MOD; the player code is the one from OpenCP. A basic sample recorder
      and editor is also included.
    '';
    homepage = "http://www.soundtracker.org/";
    downloadPage = "https://sourceforge.net/projects/soundtracker/files/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    # gdk/gdkx.h not found
    broken = stdenv.isDarwin;
  };
}
