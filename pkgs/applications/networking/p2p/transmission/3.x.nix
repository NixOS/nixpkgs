{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, cmake
, pkg-config
, openssl
, curl
, libevent
, inotify-tools
, zlib
, pcre
, libb64
, libutp_3_3
, miniupnpc
, dht
, libnatpmp
, libiconv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "transmission3";
  version = "3.00";

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "transmission";
    rev = finalAttrs.version;
    sha256 = "0ccg0km54f700x9p0jsnncnwvfnxfnxf7kcm7pcx1cj0vw78924z";
    fetchSubmodules = true;
  };

  patches = [
    # fix build with openssl 3.0
    (fetchurl {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/net-p2p/transmission/files/transmission-3.00-openssl-3.patch";
      hash = "sha256-peVrkGck8AfbC9uYNfv1CIu1alIewpca7A6kRXjVlVs=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
    curl
    libevent
    zlib
    pcre
    libb64
    libutp_3_3
    miniupnpc
    dht
    libnatpmp
  ] ++ lib.optionals stdenv.isLinux [
    inotify-tools
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ];

  cmakeFlags = [
    "-DENABLE_MAC=OFF" # requires xcodebuild
    "-DENABLE_GTK=OFF"
    "-DENABLE_QT=OFF"
    "-DENABLE_DAEMON=ON"
    "-DENABLE_CLI=OFF"
    "-DINSTALL_LIB=ON"
  ];

  meta = {
    description = "Old version of libtransmission library for apps that depend on it";
    homepage = "http://www.transmissionbt.com/";
    license = lib.licenses.gpl2Plus; # parts are under MIT
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
