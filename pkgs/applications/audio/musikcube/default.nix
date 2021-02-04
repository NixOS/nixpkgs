{ cmake
, pkg-config
, alsaLib
, boost
, curl
, fetchFromGitHub
, ffmpeg_3
, lame
, libev
, libmicrohttpd
, ncurses
, pulseaudio
, lib, stdenv
, taglib
, systemdSupport ? stdenv.isLinux, systemd
}:

stdenv.mkDerivation rec {
  pname = "musikcube";
  version = "0.96.5";

  src = fetchFromGitHub {
    owner = "clangen";
    repo = pname;
    rev = version;
    sha256 = "sha256-GxMQPP8i/NWvduf10f+xVyuG666pChj9RsiF4jfygyY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    alsaLib
    boost
    curl
    ffmpeg_3
    lame
    libev
    libmicrohttpd
    ncurses
    pulseaudio
    taglib
  ] ++ lib.optional systemdSupport systemd;

  cmakeFlags = [
    "-DDISABLE_STRIP=true"
  ];

  meta = with lib; {
    description = "A fully functional terminal-based music player, library, and streaming audio server";
    homepage = "https://musikcube.com/";
    maintainers = [ maintainers.aanderse ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
