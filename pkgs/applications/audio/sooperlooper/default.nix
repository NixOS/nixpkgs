{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
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
, alsa-lib
, fftw
}:

stdenv.mkDerivation rec {
  pname = "sooperlooper";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "essej";
    repo = "sooperlooper";
    rev = "v${builtins.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "1jng9bkb7iikad0dy1fkiq9wjjdhh1xi1p0cp2lvnz1dsc4yk6iw";
  };

  autoreconfPhase = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config which libtool ];

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
    alsa-lib
    fftw
  ];

  enableParallelBuilding = true;

  meta = with lib; {
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
