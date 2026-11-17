{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  asio,
  nettle,
  gnutls,
  msgpack-cxx,
  readline,
  libargon2,
  jsoncpp,
  restinio,
  llhttp,
  openssl,
  simdutf,
  fmt,
  nix-update-script,
  enableProxyServerAndClient ? false,
  enablePushNotifications ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opendht";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T9p/tWSNrU/MTkrLT3J33pO6q58YCmmHNOb/tbxk3YE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    asio
    fmt
    nettle
    gnutls
    msgpack-cxx
    readline
    libargon2
  ]
  ++ lib.optionals enableProxyServerAndClient [
    jsoncpp
    restinio
    llhttp
    openssl
    simdutf
  ];

  cmakeFlags =
    lib.optionals enableProxyServerAndClient [
      "-DOPENDHT_PROXY_SERVER=ON"
      "-DOPENDHT_PROXY_CLIENT=ON"
    ]
    ++ lib.optionals enablePushNotifications [
      "-DOPENDHT_PUSH_NOTIFICATIONS=ON"
    ];

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v(.+)" ];
  };

  meta = {
    description = "C++11 Kademlia distributed hash table implementation";
    homepage = "https://github.com/savoirfairelinux/opendht";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      taeer
      olynch
      thoughtpolice
    ];
    platforms = lib.platforms.unix;
  };
})
