{ cmake
, pkg-config
, boost
, curl
, fetchFromGitHub
, fetchpatch
, ffmpeg
, gnutls
, lame
, libev
, libmicrohttpd
, libopenmpt
, mpg123
, ncurses
, lib
, stdenv
, taglib
# Linux Dependencies
, alsa-lib
, pulseaudio
, systemdSupport ? stdenv.isLinux
, systemd
# Darwin Dependencies
, Cocoa
, SystemConfiguration
}:

stdenv.mkDerivation rec {
  pname = "musikcube";
  version = "0.98.0";

  src = fetchFromGitHub {
    owner = "clangen";
    repo = pname;
    rev = version;
    sha256 = "sha256-bnwOxEcvRXWPuqtkv8YlpclvH/6ZtQvyvHy4mqJCwik=";
  };

  patches = [
    ./0001-apple-cmake.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    curl
    ffmpeg
    gnutls
    lame
    libev
    libmicrohttpd
    libopenmpt
    mpg123
    ncurses
    taglib
  ] ++ lib.optionals systemdSupport [
    systemd
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib pulseaudio
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa SystemConfiguration
  ];

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
