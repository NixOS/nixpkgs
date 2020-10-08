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
  version = "0.93.1";

  src = fetchFromGitHub {
    owner = "clangen";
    repo = pname;
    rev = version;
    sha256 = "05qsxyr7x8l0vlmn4yjg4gglxvcw9raf6vfzvblsl2ngsdsrnizy";
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
