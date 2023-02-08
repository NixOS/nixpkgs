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
, libiconv
, libdeflate
, utf8cpp
, fmt
, libpsl
, python3
  # Build options
, enableGTK3 ? false
, gtkmm3
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
, darwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "transmission";
  version = "4.0.2";

  outputs = [ "out" "apparmor" ];

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "transmission";
    rev = finalAttrs.version;
    hash = "sha256-DaaJnnWEZOl6zLVxgg+U8C5ztv7Iq0wJ9yle0Gxwybc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
  ] ++ lib.optionals enableGTK3 [
    wrapGAppsHook
  ] ++ lib.optionals enableQt [
    qt5.wrapQtAppsHook
  ];

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
    libdeflate
    utf8cpp
    fmt
    libpsl
  ] ++ lib.optionals enableQt [
    qt5.qttools
    qt5.qtbase
  ] ++ lib.optionals enableGTK3 [
    gtkmm3
    xorg.libpthreadstubs
  ] ++ lib.optionals enableSystemd [
    systemd
  ] ++ lib.optionals stdenv.isLinux [
    inotify-tools
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.Foundation
  ];

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
    ] ++ lib.optionals stdenv.isDarwin [
      # Transmission sets this to 10.13 if not explicitly specified, see https://github.com/transmission/transmission/blob/0be7091eb12f4eb55f6690f313ef70a66795ee72/CMakeLists.txt#L7-L16.
      "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinMinVersion}"
    ];

  postPatch = ''
    # Clean third-party libraries to ensure system ones are used.
    # Excluding gtest since it is hardcoded to vendored version. The rest of the listed libraries are not packaged.
    pushd third-party
    for f in *; do
        if [[ ! $f =~ googletest|wildmat|fast_float|wide-integer|jsonsl ]]; then
            rm -r "$f"
        fi
    done
    popd
    rm \
      cmake/FindFmt.cmake \
      cmake/FindUtfCpp.cmake

    # Upstream uses different config file name.
    substituteInPlace CMakeLists.txt --replace 'find_package(UtfCpp)' 'find_package(utf8cpp)'
  '';

  postInstall =
    let
      rules =
        apparmorRulesFromClosure
          {
            name = "transmission-daemon";
          }
          ([
            curl
            libevent
            openssl
            pcre
            zlib
            libdeflate
            libpsl
            libnatpmp
            miniupnpc
          ] ++ lib.optionals enableSystemd [
            systemd
          ]
          ++ lib.optionals stdenv.isLinux [
            inotify-tools
          ]);
    in
    ''
      mkdir "$apparmor"
      cat >"$apparmor/bin.transmission-daemon" <<EOF
      include <tunables/global>
      $out/bin/transmission-daemon {
        include <abstractions/base>
        include <abstractions/nameservice>
        include <abstractions/ssl_certs>
        include "${rules}"
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
    maintainers = with lib.maintainers; [ astsmtl ];
    platforms = lib.platforms.unix;
  };
})
