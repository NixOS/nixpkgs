{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  python3,
  openssl,
  crc32c,
  curl,
  gtest,
  libevent,
  inotify-tools,
  systemd,
  zlib,
  pcre,
  libb64,
  libutp,
  libdeflate,
  rapidjson,
  small,
  utf8cpp,
  fmt,
  libpsl,
  miniupnpc,
  dht,
  libnatpmp,
  nix-update-script,
  wide-integer,
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
  inherit (lib) cmakeBool cmakeFeature optionals;

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
    rev = finalAttrs.version;
    hash = "sha256-glmwa06+jCyL9G2Rc58Yrvzo+/6Qu3bqwqy02RWgG64=";
    fetchSubmodules = true;
  };

  patches = [
    # build: add `USE_SYSTEM_DEFAULT` option
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/6327cc6c2e55e8885841c0094dc7d1a5cdd54b11.patch?full_index=1";
      hash = "sha256-Q0MUA7/7mvITX9es0NdyCdReRTUF0FM6FM6xMi1CDdY=";
      excludes = [
        ".github/*"
      ];
    })
    # build: infrastructure for third party submodules
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/16ec031a280b6a39e3f0b202d5e490260068eae1.patch?full_index=1";
      hash = "sha256-/2N53zwsZBD7IzbiDRcTXpW2A7g/szzN4YSrTRGrjck=";
    })
    # build: improve building with system libb64
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/9cee1d3d3b7564b8f5983f515b6d97b529fd1d27.patch?full_index=1";
      hash = "sha256-/5nR3OmK4ItjyV0mHngdmaeXVIZ+QBYLvA9w282b9yI=";
    })
    # build: support building with system {fmt}
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/665f689e44e909b05ceeed4a268823cdbb14465c.patch?full_index=1";
      hash = "sha256-E1sqwXxWkxw6ii+S3kk9AE33ZspKua108v/FzqnNXCI=";
      excludes = [
        ".github/*"
      ];
    })
    # build: improve building with system libdeflate
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/b617dea8ada34ec3a34884debc850742126c5d49.patch?full_index=1";
      hash = "sha256-xfHI5EvK/oWip+PjbfaaJ5/7/V0RTHeHwHxYj5EMAAk=";
    })
    # build: improve building with system libnatpmp
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/0845c44c1488461ebf1622fbfbce57a64b28d023.patch?full_index=1";
      hash = "sha256-XC4aT0eGMQ80y5vTfpJG51i/mkeZOGPq1lJGe1T9mG4=";
    })
    # build: improve building with system psl
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/4a900b10e735432442e21df2610cabcd0d8eb076.patch?full_index=1";
      hash = "sha256-WhhsgBIqwgNeF0BKA/VZh2d7JpySVvrB9/GtCot2S4E=";
    })
    # build: improve building with system dht
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/daf15c01c3692248051de8a5b34e899847454c47.patch?full_index=1";
      hash = "sha256-jx126uhNgm86qkis8rXVKcCz1k/efOLg1zTsLq9KQg4=";
    })
    # build: improve building with system crc32c
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/d9585782a60bf760468c5bf5aea6ff8c9aabc7b2.patch?full_index=1";
      hash = "sha256-zYmOQKf+KEfdZ+lWMTY8N7DcDcIxaG/jMuWQ5P9rrVA=";
    })
    # build: support building with system small
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/bcac3bd461055276d487f11df3dc994a5bf34cf9.patch?full_index=1";
      hash = "sha256-G8FobjaEJxMYCW+eTCLVq5KJRIiZOp3JJr4t5tpNqBE=";
      excludes = [
        ".github/*"
      ];
    })
    # build: support building with system wide-integer
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/c738b9fe4d2aac0ca2b0697b88eeb72c12494bb2.patch?full_index=1";
      hash = "sha256-soGz0bSyqwQp9qE+Bf2FAKWNXp0vqXdFW5iJPs4g40o=";
      excludes = [
        ".github/*"
      ];
    })
    # build: support building with system utf8cpp
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/e687db8f26a0693a645206bb0656d4451aa49a91.patch?full_index=1";
      hash = "sha256-+b8txQxP17e/J/T2ZKVYgWws/hAwYlk66w/9yNcuwxs=";
      excludes = [
        ".github/*"
      ];
    })
    # build: improve building with system libutp
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/357004529c0acd7235197c0d51979f8699b54b37.patch?full_index=1";
      hash = "sha256-OVa4nxKZUjluakiqmFbOqNyptyVD2YA43L4ObMiqVO4=";
    })
    # build: improve building with system miniupnpc
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/63226411dbb7cec145da7d2cda44fae4f4ae6d3b.patch?full_index=1";
      hash = "sha256-sXQgUh457XN8POPJ2YPVkrpGVOBUypNhrEfx9T7iKeM=";
    })
    # build: support building with system gtest
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/02ca4e3e2b219c1552f48eb67eac5dd1a277dce2.patch?full_index=1";
      hash = "sha256-9ta2D77h0huM0qwNDqjZ3Tv1n9uTQsHgQwjyR9rpvmk=";
      excludes = [
        ".github/*"
        "tests/libtransmission/utils-apple-test.mm"
      ];
    })
  ];

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
    (cmakeFeature "RUN_CLANG_TIDY" "OFF")
    (cmakeFeature "USE_SYSTEM_DEFAULT" "ON")
    (cmakeFeature "USE_SYSTEM_GTEST" "ON")
    (cmakeFeature "WideInteger_DIR" "${wide-integer}/lib/cmake/wide-integer/")
  ]
  ++ optionals stdenv.hostPlatform.isDarwin [
    # Transmission sets this to 10.13 if not explicitly specified, see https://github.com/transmission/transmission/blob/0be7091eb12f4eb55f6690f313ef70a66795ee72/CMakeLists.txt#L7-L16.
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinMinVersion}"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
  ]
  ++ optionals enableGTK3 [ wrapGAppsHook3 ]
  ++ optionals enableQt5 [ qt5.wrapQtAppsHook ]
  ++ optionals enableQt6 [ qt6Packages.wrapQtAppsHook ];

  buildInputs = [
    crc32c
    curl
    dht
    fmt
    gtest
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
    wide-integer
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
  '';

  passthru = {
    tests = {
      apparmor = nixosTests.transmission_4; # starts the service with apparmor enabled
      smoke-test = nixosTests.bittorrent;
    };
    updateScript = nix-update-script { };
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
