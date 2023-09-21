{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, qttools, which
, alsa-lib, libjack2, liblo, qtbase
}:

stdenv.mkDerivation rec {
  pname = "seq66";
  version = "0.90.5";

  src = fetchFromGitHub {
    owner = "ahlstromcj";
    repo = pname;
    rev = version;
    sha256 = "1jvra1wzlycfpvffnqidk264zw6fyl4fsghkw5256ldk22aalmq9";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config qttools which ];

  buildInputs = [ alsa-lib libjack2 liblo qtbase ];

  postPatch = ''
    for d in libseq66/include libseq66/src libsessions/include libsessions/src seq_qt5/src seq_rtmidi/include seq_rtmidi/src Seqtool/src; do
      substituteInPlace "$d/Makefile.am" --replace '$(git_info)' '${version}'
    done
  '';

  enableParallelBuilding = true;

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/ahlstromcj/seq66";
    description = "Loop based midi sequencer with Qt GUI derived from seq24 and sequencer64";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
