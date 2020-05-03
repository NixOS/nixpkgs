{ cmake
, pkg-config
, alsaLib
, boost
, curl
, fetchFromGitHub
, ffmpeg
, lame
, libev
, libmicrohttpd
, ncurses
, pulseaudio
, stdenv
, taglib
, systemdSupport ? stdenv.isLinux, systemd
}:

stdenv.mkDerivation rec {
  pname = "musikcube";
  version = "0.90.1";

  src = fetchFromGitHub {
    owner = "clangen";
    repo = pname;
    rev = version;
    sha256 = "1ff2cgbllrl2pl5zfbf0cd9qbf6hqpwr395sa1k245ar4f1rfwpg";
  };

  # https://github.com/clangen/musikcube/issues/339
  patches = [ ./dont-strip.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    alsaLib
    boost
    curl
    ffmpeg
    lame
    libev
    libmicrohttpd
    ncurses
    pulseaudio
    taglib
  ] ++ stdenv.lib.optional systemdSupport systemd;

  meta = with stdenv.lib; {
    description = "A fully functional terminal-based music player, library, and streaming audio server";
    homepage = "https://musikcube.com/";
    maintainers = [ maintainers.aanderse ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
