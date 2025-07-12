{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  which,
  libtool,
  liblo,
  libxml2,
  libjack2,
  libsndfile,
  wxGTK32,
  libsigcxx,
  libsamplerate,
  rubberband,
  gettext,
  ncurses,
  alsa-lib,
  fftw,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sooperlooper";
  version = "1.7.9";

  src = fetchFromGitHub {
    owner = "essej";
    repo = "sooperlooper";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-bPu/VWTJLSIMoJSEQb+/nqtTpkPtCNVuXA17XsnFSP0=";
  };

  autoreconfPhase = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    which
    libtool
  ];

  buildInputs = [
    liblo
    libxml2
    libjack2
    libsndfile
    wxGTK32
    libsigcxx
    libsamplerate
    rubberband
    gettext
    ncurses
    alsa-lib
    fftw
  ];

  # see https://bugs.gentoo.org/925275
  CPPFLAGS = "-fpermissive";

  enableParallelBuilding = true;

  meta = {
    description = "Live looping sampler capable of immediate loop recording, overdubbing, multiplying, reversing and more";
    longDescription = ''
      It allows for multiple simultaneous multi-channel loops limited only by your computer's available memory.
      The application is a standalone JACK client with an engine controllable via OSC and MIDI.
      It also includes a GUI which communicates with the engine via OSC (even over a network) for user-friendly control on a desktop.
      However, this kind of live performance looping tool is most effectively used via hardware (midi footpedals, etc)
      and the engine can be run standalone on a computer without a monitor.
    '';
    homepage = "https://sonosaurus.com/sooperlooper/";
    downloadPage = "https://github.com/essej/sooperlooper";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
  };
})
