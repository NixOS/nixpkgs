{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, openssl
, curl
, libevent
, inotify-tools
, systemd
, zlib
, pcre
, libb64
, libutp
, miniupnpc
, dht
, libnatpmp
  # Build options
, enableGTK3 ? false
, gtk3
, xorg
, wrapGAppsHook
, enableQt ? false
, qt5
, nixosTests
, enableSystemd ? stdenv.isLinux
, enableDaemon ? true
, enableCli ? true
, installLib ? false
, apparmorRulesFromClosure
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

  outputs = [ "out" "apparmor" ];

  cmakeFlags = [
    "-DENABLE_MAC=OFF" # requires xcodebuild
    "-DENABLE_GTK=${lib.boolToCMakeString enableGTK3}"
    "-DENABLE_QT=${lib.boolToCMakeString enableQt}"
    "-DENABLE_DAEMON=${lib.boolToCMakeString enableDaemon}"
    "-DENABLE_CLI=${lib.boolToCMakeString enableCli}"
    "-DINSTALL_LIB=${lib.boolToCMakeString installLib}"
  ];

  nativeBuildInputs = [
    pkg-config
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
    libb64
    libutp
    miniupnpc
    dht
    libnatpmp
  ]
  ++ lib.optionals enableQt [ qt5.qttools qt5.qtbase ]
  ++ lib.optionals enableGTK3 [ gtk3 xorg.libpthreadstubs ]
  ++ lib.optionals enableSystemd [ systemd ]
  ++ lib.optionals stdenv.isLinux [ inotify-tools ]
  ;

  postInstall = ''
    mkdir $apparmor
    cat >$apparmor/bin.transmission-daemon <<EOF
    include <tunables/global>
    $out/bin/transmission-daemon {
      include <abstractions/base>
      include <abstractions/nameservice>
      include <abstractions/ssl_certs>
      include "${apparmorRulesFromClosure { name = "transmission-daemon"; } ([
        curl libevent openssl pcre zlib libnatpmp miniupnpc
      ] ++ lib.optionals enableSystemd [ systemd ]
        ++ lib.optionals stdenv.isLinux [ inotify-tools ]
      )}"
      r @{PROC}/sys/kernel/random/uuid,
      r @{PROC}/sys/vm/overcommit_memory,
      r @{PROC}/@{pid}/environ,
      r @{PROC}/@{pid}/mounts,
      rwk /tmp/tr_session_id_*,

      r $out/share/transmission/web/**,

      include <local/bin.transmission-daemon>
    }
    EOF
  '';

  passthru.tests = {
    apparmor = nixosTests.transmission; # starts the service with apparmor enabled
    smoke-test = nixosTests.bittorrent;
  };

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
    license = lib.licenses.gpl2Plus; # parts are under MIT
    maintainers = with lib.maintainers; [ astsmtl vcunat wizeman ];
    platforms = lib.platforms.unix;
  };

}
