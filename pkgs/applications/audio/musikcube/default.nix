{ cmake
, pkg-config
, alsa-lib
, boost
, curl
, fetchFromGitHub
, ffmpeg
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
  version = "0.96.7";

  src = fetchFromGitHub {
    owner = "clangen";
    repo = pname;
    rev = version;
    sha256 = "1y00vwn1h10cfflxrm5bk271ak9gilhjycgi44hlkkhmf5bdgn35";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    boost
    curl
    ffmpeg
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
