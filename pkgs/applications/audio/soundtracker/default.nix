{ lib, stdenv
, fetchzip
, pkg-config
, autoreconfHook
, gtk2
, alsa-lib
, SDL
, jack2
, audiofile
, goocanvas # graphical envelope editing
, libxml2
, libsndfile
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soundtracker";
  version = "1.0.5";

  src = fetchzip {
    # Past releases get moved to the "old releases" directory.
    # Only the latest release is at the top level.
    # Nonetheless, only the name of the file seems to affect which file is
    # downloaded, so this path should be fine both for old and current releases.
    url = "mirror://sourceforge/soundtracker/soundtracker-${finalAttrs.version}.tar.xz";
    hash = "sha256-g96Z1SdFGMq7WFI6x+UtmAHPZF0C+tHUOjNhmK2ld8I=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Darwin binutils don't support D option for ar
    # ALSA macros are missing on Darwin, causing error
    substituteInPlace configure.ac \
      --replace ARFLAGS=crD ARFLAGS=cru \
      --replace AM_PATH_ALSA '#AM_PATH_ALSA'
    # Avoid X11-specific workaround code on more than just Windows
    substituteInPlace app/keys.c \
      --replace '!defined(_WIN32)' '!defined(_WIN32) && !defined(__APPLE__)'
    # "The application with bundle ID (null) is running setugid(), which is not allowed."
    sed -i -e '/seteuid/d' -e '/setegid/d' app/main.c
  '';

  configureFlags = [
    "--with-graphics-backend=gdk"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--disable-alsa"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    gtk2
    SDL
    jack2
    audiofile
    goocanvas
    libxml2
    libsndfile
  ] ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib;

  meta = with lib; {
    description = "Music tracking tool similar in design to the DOS program FastTracker and the Amiga legend ProTracker";
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
    hydraPlatforms = platforms.linux; # sdl-config times out on darwin
  };
})
