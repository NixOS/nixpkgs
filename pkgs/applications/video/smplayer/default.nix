{ lib
, stdenv
, fetchFromGitHub
, qmake
, qtscript
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "smplayer";
  version = "21.10.0";

  src = fetchFromGitHub {
    owner = "smplayer-dev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-p6036c8KX3GCINmkjHZlDLgHhLKri+t2WNWzP4KsSI8=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [ qtscript ];

  dontUseQmakeConfigure = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    homepage = "https://www.smplayer.info";
    description = "A complete front-end for MPlayer";
    longDescription = ''
      SMPlayer is a free media player for Windows and Linux with built-in codecs
      that can play virtually all video and audio formats. It doesn't need any
      external codecs. Just install SMPlayer and you'll be able to play all
      formats without the hassle to find and install codec packs.

      One of the most interesting features of SMPlayer: it remembers the
      settings of all files you play. So you start to watch a movie but you have
      to leave... don't worry, when you open that movie again it will be resumed
      at the same point you left it, and with the same settings: audio track,
      subtitles, volume...

      SMPlayer is a graphical user interface (GUI) for the award-winning
      MPlayer, which is capable of playing almost all known video and audio
      formats. But apart from providing access for the most common and useful
      options of MPlayer, SMPlayer adds other interesting features like the
      possibility to play Youtube videos or download subtitles.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
# TODO [ AndersonTorres ]: some form of wrapping mplayer/mpv around it
