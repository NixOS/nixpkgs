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
  version = "0.97.0";

  src = fetchFromGitHub {
    owner = "clangen";
    repo = pname;
    rev = version;
    sha256 = "sha256-W9Ng1kqai5qhaDs5KWg/1sOTIAalBXLng1MG8sl/ZOg=";
  };

  patches = [
    # Fix pending upstream inclusion for ncurses-6.3 support:
    #  https://github.com/clangen/musikcube/pull/474
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/clangen/musikcube/commit/1240720e27232fdb199a4da93ca6705864442026.patch";
      sha256 = "0bhjgwnj6d24wb1m9xz1vi1k9xk27arba1absjbcimggn54pinid";
    })
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
