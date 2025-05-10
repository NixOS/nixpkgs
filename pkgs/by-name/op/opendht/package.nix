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
  fetchpatch2,
  enableProxyServerAndClient ? false,
  enablePushNotifications ? false,
}:

stdenv.mkDerivation {
  pname = "opendht";
  version = "3.2.0-unstable-2025-01-05";

  src = fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "opendht";
    rev = "5237f0a3b3eb8965f294de706ad73596569ae1dd";
    hash = "sha256-qErVKyZQR/asJ8qr0sRDaXZ8jUV7RaSLnJka5baWa7Q=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/savoirfairelinux/opendht/commit/2c26030108ede63e74efcc2d9c23ad47fdc8372e.patch?full_index=1";
      hash = "sha256-kWXQZ2NS9xUUPKQVaJn4DyOdhtwnNCNcYtvzex/60dk=";
    })
    (fetchpatch2 {
      url = "https://github.com/savoirfairelinux/opendht/commit/2bc46e9657c94adcce2479807a0a04c2f783bd4e.patch?full_index=1";
      hash = "sha256-Zb1JrggIT4ghK+h0QZmLfLHZwbp5LFW68gwhRM3J1Ko=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
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

  # https://github.com/savoirfairelinux/opendht/issues/612
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '\$'{exec_prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

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
