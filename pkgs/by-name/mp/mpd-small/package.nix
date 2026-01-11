{
  lib,
  stdenv,
  mpd,
}:

mpd.override {
  features = [
    "webdav"
    "curl"
    "mms"
    "bzip2"
    "zzip"
    "nfs"
    "audiofile"
    "faad"
    "flac"
    "gme"
    "mpg123"
    "opus"
    "vorbis"
    "vorbisenc"
    "lame"
    "libsamplerate"
    "shout"
    "libmpdclient"
    "id3tag"
    "expat"
    "pcre"
    "sqlite"
    "qobuz"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "alsa"
    "systemd"
    "syslog"
    "io_uring"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "mad"
    "jack"
  ];
}
