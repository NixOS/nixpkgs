{
  lib,
  stdenv,
  fetchFromGitHub,
  qt5,
}:

let
  inherit (qt5) qmake qtscript wrapQtAppsHook;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "smplayer";
  version = "23.12.0";

  src = fetchFromGitHub {
    owner = "smplayer-dev";
    repo = "smplayer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ip4y9GF2u1yl1Ts8T9XcFg9wdXVTYXfDrrPuHLz6oSs=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [ qtscript ];

  dontUseQmakeConfigure = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
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
    changelog = "https://github.com/smplayer-dev/smplayer/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
# TODO [ AndersonTorres ]: create a wrapper including mplayer/mpv
