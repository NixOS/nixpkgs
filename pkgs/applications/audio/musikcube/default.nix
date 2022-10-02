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

  patches = []
    ++ lib.optionals stdenv.isDarwin [
      # Fix pending upstream inclusion for Darwin nixpkgs builds:
      # https://github.com/clangen/musikcube/pull/531
      (fetchpatch {
        name = "darwin-build.patch";
        url = "https://github.com/clangen/musikcube/commit/9077bb9fa6ddfe93ebb14bb8feebc8a0ef9b7ee4.patch";
        sha256 = "sha256-Am9AGKDGMN5z+JJFJKdsBLrHf2neHFovgF/8I5EXLDA=";
      })
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

  postFixup = lib.optionals stdenv.isDarwin ''
    install_name_tool -add_rpath $out/share/${pname} $out/share/${pname}/${pname}
    install_name_tool -add_rpath $out/share/${pname} $out/share/${pname}/${pname}d
  '';

  meta = with lib; {
    description = "A fully functional terminal-based music player, library, and streaming audio server";
    homepage = "https://musikcube.com/";
    maintainers = [ maintainers.aanderse ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
