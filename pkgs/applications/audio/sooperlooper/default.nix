{ stdenv, fetchurl, liblo, libxml2, jack2, libsndfile, wxGTK, libsigcxx
,libsamplerate, rubberband, pkgconfig, ncurses
}:

stdenv.mkDerivation rec {
  name = "sooperlooper-${version}";
  version = "1.7.3";
  src = fetchurl {
    url = "http://essej.net/sooperlooper/${name}.tar.gz";
    sha256 = "0n2gdxw1fx8nxxnpzf4sj0kp6k6zi1yq59cbz6qqzcnsnpnvszbs";
  };

  buildInputs = [
   liblo libxml2 jack2 libsndfile wxGTK libsigcxx
   libsamplerate rubberband pkgconfig ncurses
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
    homepage = "http://essej.net/sooperlooper/index.html";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
