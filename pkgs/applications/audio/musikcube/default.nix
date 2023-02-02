{ lib
, stdenv
, cmake
, pkg-config
, curl
, asio
, fetchFromGitHub
, fetchpatch
, ffmpeg
, gnutls
, lame
, libev
, game-music-emu
, libmicrohttpd
, libopenmpt
, mpg123
, ncurses
, taglib
# Linux Dependencies
, alsa-lib
, pulseaudio
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd
, systemd
# Darwin Dependencies
, Cocoa
, SystemConfiguration
}:

stdenv.mkDerivation rec {
  pname = "musikcube";
  version = "0.99.4";

  src = fetchFromGitHub {
    owner = "clangen";
    repo = pname;
    rev = version;
    sha256 = "sha256-GAO3CKtlZF8Ol4K+40lD8n2RtewiHj3f59d5RIatNws=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    asio
    curl
    ffmpeg
    gnutls
    lame
    libev
    game-music-emu
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
