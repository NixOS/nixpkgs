{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkgconfig
, openssl
, curl
, libevent
, inotify-tools
, systemd
, zlib
, pcre
  # Build options
, enableGTK3 ? false
, gnome3
, xorg
, wrapGAppsHook
, enableQt ? false
, qt5
, enableSystemd ? stdenv.isLinux
, enableDaemon ? true
, enableCli ? true
}:

let
  version = "3.00";

in stdenv.mkDerivation {
  pname = "transmission";
  inherit version;

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "transmission";
    rev = version;
    sha256 = "0ccg0km54f700x9p0jsnncnwvfnxfnxf7kcm7pcx1cj0vw78924z";
    fetchSubmodules = true;
  };

  cmakeFlags =
    let
      mkFlag = opt: if opt then "ON" else "OFF";
    in
    [
      "-DENABLE_MAC=OFF" # requires xcodebuild
      "-DENABLE_GTK=${mkFlag enableGTK3}"
      "-DENABLE_QT=${mkFlag enableQt}"
      "-DENABLE_DAEMON=${mkFlag enableDaemon}"
      "-DENABLE_CLI=${mkFlag enableCli}"
    ];

  nativeBuildInputs = [
    pkgconfig
    cmake
  ]
  ++ lib.optionals enableGTK3 [ wrapGAppsHook ]
  ++ lib.optionals enableQt [ qt5.wrapQtAppsHook ]
  ;

  buildInputs = [
    openssl
    curl
    libevent
    zlib
    pcre
  ]
  ++ lib.optionals enableQt [ qt5.qttools qt5.qtbase ]
  ++ lib.optionals enableGTK3 [ gnome3.gtk xorg.libpthreadstubs ]
  ++ lib.optionals enableSystemd [ systemd ]
  ++ lib.optionals stdenv.isLinux [ inotify-tools ]
  ;

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework CoreFoundation";

  meta = {
    description = "A fast, easy and free BitTorrent client";
    longDescription = ''
      Transmission is a BitTorrent client which features a simple interface
      on top of a cross-platform back-end.
      Feature spotlight:
        * Uses fewer resources than other clients
        * Native Mac, GTK and Qt GUI clients
        * Daemon ideal for servers, embedded systems, and headless use
        * All these can be remote controlled by Web and Terminal clients
        * Bluetack (PeerGuardian) blocklists with automatic updates
        * Full encryption, DHT, and PEX support
    '';
    homepage = "http://www.transmissionbt.com/";
    license = lib.licenses.gpl2; # parts are under MIT
    maintainers = with lib.maintainers; [ astsmtl vcunat wizeman ];
    platforms = lib.platforms.unix;
  };

}
