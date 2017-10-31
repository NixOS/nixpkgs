{ stdenv, fetchFromGitHub, liblo, libxml2, libjack2, libsndfile, wxGTK, libsigcxx
, libsamplerate, rubberband, pkgconfig, libtool, gettext, ncurses, which
, autoreconfHook
}:

stdenv.mkDerivation rec {
  name = "sooperlooper-git-${version}";
  version = "2016-07-19";

  src = fetchFromGitHub {
    owner = "essej";
    repo = "sooperlooper";
    rev = "3bdfe184cd59b51c757b8048536abc1146fb0de4";
    sha256 = "0qz25h4idv79m97ici2kzx72fwzks3lysyksk3p3rx72lsijhf3g";
  };

  autoreconfPhase = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig which libtool ];

  buildInputs = [
    liblo libxml2 libjack2 libsndfile wxGTK libsigcxx
    libsamplerate rubberband gettext ncurses
  ];

  meta = {
    description = "A live looping sampler capable of immediate loop recording, overdubbing, multiplying, reversing and more";
    longDescription = ''
      It allows for multiple simultaneous multi-channel loops limited only by your computer's available memory.
      The application is a standalone JACK client with an engine controllable via OSC and MIDI.
      It also includes a GUI which communicates with the engine via OSC (even over a network) for user-friendly control on a desktop.
      However, this kind of live performance looping tool is most effectively used via hardware (midi footpedals, etc)
      and the engine can be run standalone on a computer without a monitor.
    '';

    version = "${version}";
    homepage = http://essej.net/sooperlooper/index.html;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
