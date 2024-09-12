{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, qttools, which
, alsa-lib, libjack2, liblo, qtbase, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "seq66";
  version = "0.99.14";

  src = fetchFromGitHub {
    owner = "ahlstromcj";
    repo = "seq66";
    rev = version;
    hash = "sha256-0xexKu8qQd0HzEHYKMomeoBE1s/tC5T1jzUl+AkhTqY=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config qttools which wrapQtAppsHook ];

  buildInputs = [ alsa-lib libjack2 liblo qtbase ];

  postPatch = ''
    for d in libseq66/src libsessions/include libsessions/src seq_qt5/src seq_rtmidi/src; do
      substituteInPlace "$d/Makefile.am" --replace-fail '$(git_info)' '${version}'
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/ahlstromcj/seq66";
    description = "Loop based midi sequencer with Qt GUI derived from seq24 and sequencer64";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    mainProgram = "qseq66";
    platforms = platforms.linux;
  };
}
