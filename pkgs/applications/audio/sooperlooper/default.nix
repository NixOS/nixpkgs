{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, which
, libtool
, liblo
, libxml2
, libjack2
, libsndfile
, wxGTK30
, libsigcxx
, libsamplerate
, rubberband
, gettext
, ncurses
, alsaLib
, fftw
}:

stdenv.mkDerivation rec {
  pname = "sooperlooper";
  version = "unstable-2019-09-30";

  src = fetchFromGitHub {
    owner = "essej";
    repo = "sooperlooper";
    rev = "4d1da14176e16b0f56b727bb1e6c2e8957515625";
    sha256 = "1gsgqa7hdymzw2al1ymzv0f33y161dyhh3fmy88lpjwv3bfchamg";
  };

  autoreconfPhase = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig which libtool ];

  buildInputs = [
    liblo
    libxml2
    libjack2
    libsndfile
    wxGTK30
    libsigcxx
    libsamplerate
    rubberband
    gettext
    ncurses
    alsaLib
    fftw
  ];

  meta = with stdenv.lib; {
    description = "A live looping sampler capable of immediate loop recording, overdubbing, multiplying, reversing and more";
    longDescription = ''
      It allows for multiple simultaneous multi-channel loops limited only by your computer's available memory.
      The application is a standalone JACK client with an engine controllable via OSC and MIDI.
      It also includes a GUI which communicates with the engine via OSC (even over a network) for user-friendly control on a desktop.
      However, this kind of live performance looping tool is most effectively used via hardware (midi footpedals, etc)
      and the engine can be run standalone on a computer without a monitor.
    '';
    homepage = "http://essej.net/sooperlooper/"; # https is broken
    license = licenses.gpl2;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
