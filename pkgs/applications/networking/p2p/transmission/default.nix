{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, cmake
, pkg-config
, python3
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
, libiconv
  # Build options
, enableGTK3 ? false
, gtk3
, xorg
, wrapGAppsHook
, enableQt ? false
, qt5
, nixosTests
, enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, enableDaemon ? true
, enableCli ? true
, installLib ? false
, apparmorRulesFromClosure
}:

let
  version = "4.0.2";

in stdenv.mkDerivation {
  pname = "transmission";
  inherit version;

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "transmission";
    rev = version;
    sha256 = "DaaJnnWEZOl6zLVxgg+U8C5ztv7Iq0wJ9yle0Gxwybc=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "apparmor" ];

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
      "-DINSTALL_LIB=${mkFlag installLib}"
    ];

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
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
  ++ lib.optionals stdenv.isDarwin [ libiconv ];

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
    maintainers = with lib.maintainers; [ astsmtl stephenmw vcunat wizeman ];
    platforms = lib.platforms.unix;
  };

}
