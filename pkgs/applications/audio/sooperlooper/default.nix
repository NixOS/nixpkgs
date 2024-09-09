{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, pkg-config
, which
, libtool
, liblo
, libxml2
, libjack2
, libsndfile
, wxGTK32
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
  version = "1.7.8";

  src = fetchFromGitHub {
    owner = "essej";
    repo = "sooperlooper";
    rev = "v${version}";
    sha256 = "sha256-Lrsz/UDCgoac63FJ3CaPVaYwvBtzkGQQRLhUi6lUusE=";
  };

  patches = [
    (fetchpatch {
      name = "10-build_with_wx_32.patch";
      url = "https://sources.debian.org/data/main/s/sooperlooper/1.7.8~dfsg0-2/debian/patches/10-build_with_wx_32.patch";
      sha256 = "sha256-NF/w+zgRBNkSTqUJhfH9kQogXSYEF70pCN+loR0hjpg=";
    })
  ];

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

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Live looping sampler capable of immediate loop recording, overdubbing, multiplying, reversing and more";
    longDescription = ''
      It allows for multiple simultaneous multi-channel loops limited only by your computer's available memory.
      The application is a standalone JACK client with an engine controllable via OSC and MIDI.
      It also includes a GUI which communicates with the engine via OSC (even over a network) for user-friendly control on a desktop.
      However, this kind of live performance looping tool is most effectively used via hardware (midi footpedals, etc)
      and the engine can be run standalone on a computer without a monitor.
    '';
    homepage = "https://sonosaurus.com/sooperlooper/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
