{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  openssl,
  curl,
  libevent,
  inotify-tools,
  systemd,
  zlib,
  pcre,
  rapidjson,
  small,
  libb64,
  libutp,
  libdeflate,
  utf8cpp,
  fast-float,
  fmt,
  libpsl,
  miniupnpc,
  crc32c,
  dht,
  libnatpmp,
  libiconv,
  # Build options
  enableGTK3 ? false,
  gtkmm3,
  libpthread-stubs,
  wrapGAppsHook3,
  enableQt5 ? false,
  enableQt6 ? false,
  qt5,
  qt6Packages,
  nixosTests,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  enableDaemon ? true,
  enableCli ? true,
  installLib ? false,
  apparmorRulesFromClosure,
}:

let
  inherit (lib) cmakeBool optionals;

  apparmorRules = apparmorRulesFromClosure { name = "transmission-daemon"; } (
    [
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
    ++ optionals stdenv.hostPlatform.isLinux [ inotify-tools ]
  );

in
stdenv.mkDerivation (finalAttrs: {
  pname = "transmission";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "transmission";
    tag = finalAttrs.version;
    hash = "sha256-glmwa06+jCyL9G2Rc58Yrvzo+/6Qu3bqwqy02RWgG64=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "apparmor"
  ];

  cmakeFlags = [
    (cmakeBool "ENABLE_CLI" enableCli)
    (cmakeBool "ENABLE_DAEMON" enableDaemon)
    (cmakeBool "ENABLE_GTK" enableGTK3)
    (cmakeBool "ENABLE_MAC" false) # requires xcodebuild
    (cmakeBool "ENABLE_QT" (enableQt5 || enableQt6))
    (cmakeBool "INSTALL_LIB" installLib)
  ]
  ++ optionals stdenv.hostPlatform.isDarwin [
    # Transmission sets this to 10.13 if not explicitly specified, see https://github.com/transmission/transmission/blob/0be7091eb12f4eb55f6690f313ef70a66795ee72/CMakeLists.txt#L7-L16.
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinMinVersion}"
  ];

  postPatch = ''
    # Clean third-party libraries to ensure system ones are used.
    # Excluding gtest since it is hardcoded to vendored version. The rest of the listed libraries are not packaged.
    pushd third-party
    for f in *; do
        if [[ ! $f =~ googletest|wildmat|wide-integer|jsonsl ]]; then
            rm -r "$f"
        fi
    done
    popd
    rm \
      cmake/FindFastFloat.cmake \
      cmake/FindFmt.cmake \
      cmake/FindRapidJSON.cmake \
      cmake/FindSmall.cmake \
      cmake/FindUtfCpp.cmake
    # Upstream uses different config file name.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'find_package(UtfCpp)' 'find_package(utf8cpp)'
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
  ]
  ++ optionals enableGTK3 [ wrapGAppsHook3 ]
  ++ optionals enableQt5 [ qt5.wrapQtAppsHook ]
  ++ optionals enableQt6 [ qt6Packages.wrapQtAppsHook ];

  buildInputs = [
    curl
    crc32c
    dht
    fast-float
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
    rapidjson
    small
    utf8cpp
    zlib
  ]
  ++ optionals enableQt5 (
    with qt5;
    [
      qttools
      qtbase
    ]
  )
  ++ optionals enableQt6 (
    with qt6Packages;
    [
      qttools
      qtbase
      qtsvg
    ]
  )
  ++ optionals enableGTK3 [
    gtkmm3
    libpthread-stubs
  ]
  ++ optionals enableSystemd [ systemd ]
  ++ optionals stdenv.hostPlatform.isLinux [ inotify-tools ];

  postInstall = ''
    mkdir $apparmor
    cat >$apparmor/bin.transmission-daemon <<EOF
    abi <abi/4.0>,
    include <tunables/global>
    profile $out/bin/transmission-daemon {
      include <abstractions/base>
      include <abstractions/nameservice>
      include <abstractions/ssl_certs>
      include "${apparmorRules}"
      @{PROC}/sys/kernel/random/uuid r,
      @{PROC}/sys/vm/overcommit_memory r,
      @{PROC}/@{pid}/environ r,
      @{PROC}/@{pid}/mounts r,
      /tmp/tr_session_id_* rwk,

      $out/share/transmission/public_html/** r,

      include if exists <local/bin.transmission-daemon>
    }
    EOF
    install -Dm0444 -t $out/share/icons ../icons/hicolor_apps_scalable_transmission.svg
  '';

  passthru.tests = {
    apparmor = nixosTests.transmission_4; # starts the service with apparmor enabled
    smoke-test = nixosTests.bittorrent;
  };

  meta = {
    description = "Fast, easy and free BitTorrent client";
    mainProgram =
      if (enableQt5 || enableQt6) then
        "transmission-qt"
      else if enableGTK3 then
        "transmission-gtk"
      else
        "transmission-cli";
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
    license = with lib.licenses; [
      gpl2Plus
      mit
    ];
    platforms = lib.platforms.unix;
  };
})
