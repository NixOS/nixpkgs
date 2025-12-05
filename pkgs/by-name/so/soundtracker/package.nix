{
  lib,
  stdenv,
  fetchzip,
  pkg-config,
  autoreconfHook,
  gtk2,
  alsa-lib,
  SDL,
  jack2,
  audiofile,
  goocanvas, # graphical envelope editing
  libxml2,
  libsndfile,
  libpulseaudio,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soundtracker";
  version = "1.0.5.1";

  src = fetchzip {
    # Past releases get moved to the "old releases" directory.
    # Only the latest release is at the top level.
    # Nonetheless, only the name of the file seems to affect which file is
    # downloaded, so this path should be fine both for old and current releases.
    url = "mirror://sourceforge/soundtracker/soundtracker-${finalAttrs.version}.tar.xz";
    hash = "sha256-pvBCPPu8jBq9CFbSlKewEI+3t092zmtq+pbNLeJWU/8=";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail 'AM_PATH_XML2(2.6.0, [], AC_MSG_ERROR(Fatal error: Need libxml2 >= 2.6.0))' \
          'PKG_CHECK_MODULES([XML], [libxml-2.0 >= 2.6.0])' \
      --replace-fail 'XML_CPPFLAGS' 'XML_CFLAGS'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--disable-alsa"
  ];

  enableParallelBuilding = true;

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    SDL # AM_PATH_SDL
    glib # glib-genmarshal
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib # AM_PATH_ALSA
  ];

  buildInputs = [
    gtk2
    SDL # found by AM_PATH_SDL
    jack2
    audiofile
    goocanvas
    libxml2 # found by PKG_CHECK_MODULES
    libsndfile
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib # found by AM_PATH_ALSA
    libpulseaudio # found by PKG_CHECK_MODULES
  ];

  meta = {
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
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    hydraPlatforms = lib.platforms.linux; # sdl-config times out on darwin
  };
})
