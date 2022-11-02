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
  version = "0.98.1";

  src = fetchFromGitHub {
    owner = "clangen";
    repo = pname;
    rev = version;
    sha256 = "sha256-pnAdlCCqWzR0W8dF9CE48K8yHMVIx3egZlXvibxU18A=";
  };

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

  postFixup = lib.optionals stdenv.isDarwin ''
    install_name_tool -add_rpath $out/share/${pname} $out/share/${pname}/${pname}
    install_name_tool -add_rpath $out/share/${pname} $out/share/${pname}/${pname}d
  '';

  meta = with lib; {
    description = "A fully functional terminal-based music player, library, and streaming audio server";
    homepage = "https://musikcube.com/";
    maintainers = with maintainers; [ aanderse srapenne ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
