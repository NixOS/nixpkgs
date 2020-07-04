{ stdenv, fetchFromGitHub, cmake, pkg-config, qttools
, alsaLib, ftgl, libGLU, libjack2, qtbase, rtmidi
}:

stdenv.mkDerivation rec {
  pname = "pianobooster";
  version = "0.7.2b";

  src = fetchFromGitHub {
    owner = "captnfab";
    repo = "PianoBooster";
    rev = "v${version}";
    sha256 = "03xcdnlpsij22ca3i6xj19yqzn3q2ch0d32r73v0c96nm04gvhjj";
  };

  nativeBuildInputs = [ cmake pkg-config qttools ];

  buildInputs = [ alsaLib ftgl libGLU libjack2 qtbase rtmidi ];

  cmakeFlags = [
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  meta = with stdenv.lib; {
    description = "A MIDI file player that teaches you how to play the piano";
    homepage = "https://github.com/captnfab/PianoBooster";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu orivej ];
  };
}
