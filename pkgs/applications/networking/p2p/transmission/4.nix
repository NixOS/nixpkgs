{ stdenv
, lib
, fetchFromGitHub
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
, libdeflate
, utf8cpp
, fmt
, libpsl
, miniupnpc
, dht
, libnatpmp
, libiconv
, Foundation
  # Build options
, enableGTK3 ? false
, gtkmm3
, xorg
, wrapGAppsHook3
, enableQt5 ? false
, enableQt6 ? false
, qt5
, qt6Packages
, nixosTests
, enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, enableDaemon ? true
, enableCli ? true
, installLib ? false
, apparmorRulesFromClosure
}:

let
  inherit (lib) cmakeBool optionals;

  apparmorRules = apparmorRulesFromClosure { name = "transmission-daemon"; } ([
    curl
    libdeflate
    libevent
    libnatpmp
    libpsl
    miniupnpc
    openssl
    pcre
    zlib
  ]
  ++ optionals enableSystemd [ systemd ]
  ++ optionals stdenv.isLinux [ inotify-tools ]);

in
stdenv.mkDerivation (finalAttrs: {
  pname = "transmission";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "transmission";
    rev = finalAttrs.version;
    hash = "sha256-KBXvBFgrJ3njIoXrxHbHHLsiocwfd7Eba/GNI8uZA38=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "apparmor" ];

  cmakeFlags = [
    (cmakeBool "ENABLE_CLI" enableCli)
    (cmakeBool "ENABLE_DAEMON" enableDaemon)
    (cmakeBool "ENABLE_GTK" enableGTK3)
    (cmakeBool "ENABLE_MAC" false) # requires xcodebuild
    (cmakeBool "ENABLE_QT" (enableQt5 || enableQt6))
    (cmakeBool "INSTALL_LIB" installLib)
  ] ++ optionals stdenv.isDarwin [
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

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
  ]
  ++ optionals enableGTK3 [ wrapGAppsHook3 ]
  ++ optionals enableQt5 [ qt5.wrapQtAppsHook ]
  ++ optionals enableQt6 [ qt6Packages.wrapQtAppsHook ]
  ;

  buildInputs = [
    curl
    dht
    fmt
    libb64
    libdeflate
    libevent
    libnatpmp
    libpsl
    libutp
    miniupnpc
    openssl
    pcre
    utf8cpp
    zlib
  ]
  ++ optionals enableQt5 (with qt5; [ qttools qtbase ])
  ++ optionals enableQt6 (with qt6Packages; [ qttools qtbase qtsvg ])
  ++ optionals enableGTK3 [ gtkmm3 xorg.libpthreadstubs ]
  ++ optionals enableSystemd [ systemd ]
  ++ optionals stdenv.isLinux [ inotify-tools ]
  ++ optionals stdenv.isDarwin [ libiconv Foundation ];

  postInstall = ''
    mkdir $apparmor
    cat >$apparmor/bin.transmission-daemon <<EOF
    include <tunables/global>
    $out/bin/transmission-daemon {
      include <abstractions/base>
      include <abstractions/nameservice>
      include <abstractions/ssl_certs>
      include "${apparmorRules}"
      r @{PROC}/sys/kernel/random/uuid,
      r @{PROC}/sys/vm/overcommit_memory,
      r @{PROC}/@{pid}/environ,
      r @{PROC}/@{pid}/mounts,
      rwk /tmp/tr_session_id_*,

      r $out/share/transmission/public_html/**,

      include <local/bin.transmission-daemon>
    }
    EOF
    install -Dm0444 -t $out/share/icons ../qt/icons/transmission.svg
  '';

  passthru.tests = {
    apparmor = nixosTests.transmission_4; # starts the service with apparmor enabled
    smoke-test = nixosTests.bittorrent;
  };

  meta = with lib; {
    description = "A fast, easy and free BitTorrent client";
    mainProgram = if (enableQt5 || enableQt6) then "transmission-qt" else if enableGTK3 then "transmission-gtk" else "transmission-cli";
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
    homepage = "https://www.transmissionbt.com/";
    license = with licenses; [ gpl2Plus mit ];
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.unix;
  };
})
