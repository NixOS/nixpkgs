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
  fmt,
  nix-update-script,
  enableProxyServerAndClient ? false,
  enablePushNotifications ? false,
}:

stdenv.mkDerivation rec {
  pname = "opendht";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    tag = "v${version}";
    hash = "sha256-WNN4aCZiJuz9CgEKIzFmy50HBj0ZL/d1uU7L518lPhk=";
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

  meta = with lib; {
    description = "C++11 Kademlia distributed hash table implementation";
    homepage = "https://github.com/savoirfairelinux/opendht";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      taeer
      olynch
      thoughtpolice
    ];
    platforms = platforms.unix;
  };
}
