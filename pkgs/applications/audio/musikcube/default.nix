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
, stdenv
, taglib
, systemdSupport ? stdenv.isLinux, systemd
}:

stdenv.mkDerivation rec {
  pname = "musikcube";
  version = "0.96.1";

  src = fetchFromGitHub {
    owner = "clangen";
    repo = pname;
    rev = version;
    sha256 = "0gpyr25q6g9b8f9hi6jx3p4ijl7xrrjc78vw1fyjd59a7690d7kr";
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
  ] ++ stdenv.lib.optional systemdSupport systemd;

  cmakeFlags = [
    "-DDISABLE_STRIP=true"
  ];

  meta = with stdenv.lib; {
    description = "A fully functional terminal-based music player, library, and streaming audio server";
    homepage = "https://musikcube.com/";
    maintainers = [ maintainers.aanderse ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
