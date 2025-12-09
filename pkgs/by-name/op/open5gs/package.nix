{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  talloc,
  pkg-config,
  mongoc,
  cmake,
  libyaml,
  libmicrohttpd,
  flex,
  bison,
  libgcrypt,
  libidn,
  lksctp-tools,
  gnutls,
  libnghttp2,
  openssl,
  curl,
  libtins,
  mongosh,
  usrsctp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open5gs";
  version = "2.7.6";

  diameter = fetchFromGitHub {
    owner = "open5gs";
    repo = "freeDiameter";
    rev = "13f5a5996b5fa1a46ed780635c7fc6fcd09b4290"; # r1.5.0
    hash = "sha256-S8jL+9rW9RDwQc7NU8MOzMe9/iRbshWa2QLqXoiV85Q=";
  };

  libtins = fetchFromGitHub {
    owner = "open5gs";
    repo = "libtins";
    rev = "fb152ba63bd8d7d024d5f86e5fbd24a4cb3dd93d"; # r4.3
    hash = "sha256-q++F1bvf739P82VpUf4TUygHjhYwOsaQzStJv8PN2Hc=";
  };

  mesonFlags = [
    "-Dwerror=false"
    "--buildtype=release"
  ];

  promc = fetchFromGitHub {
    owner = "open5gs";
    repo = "prometheus-client-c";
    rev = "a58ba25bf87a9b1b7c6be4e6f4c62047d620f402"; # open5gs branch
    hash = "sha256-COZV4UeB7YRfpLwloIfc/WdlTP9huwVfXrJWH4jmvB8=";
  };

  src = fetchFromGitHub {
    owner = "open5gs";
    repo = "open5gs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2k+S+OXfdskJPtDUFSxb/+2UZcUiOZzRSSGgsEJWolc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    flex
    bison
  ];

  buildInputs = [
    talloc
    mongoc
    libyaml
    libmicrohttpd
    libgcrypt
    libidn
    openssl
    curl
    libtins
    gnutls
    libnghttp2.dev
  ]
  ++ lib.optionals stdenv.isLinux [
    lksctp-tools
  ]
  ++ lib.optionals (!stdenv.isLinux) [
    usrsctp
  ];

  preConfigure = ''
    cp -R --no-preserve=mode,ownership ${finalAttrs.diameter} subprojects/freeDiameter
    cp -R --no-preserve=mode,ownership ${finalAttrs.libtins} subprojects/libtins
    cp -R --no-preserve=mode,ownership ${finalAttrs.promc} subprojects/prometheus-client-c
  '';

  postInstall = ''
    cp misc/db/open5gs-dbctl $out/bin
    substituteInPlace $out/bin/open5gs-dbctl \
      --replace "mongosh" "${lib.getExe mongosh}"
  '';

  meta = {
    homepage = "https://open5gs.org/";
    description = "4G/5G core network components";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      bot-wxt1221
      xddxdd
    ];
    changelog = "https://github.com/open5gs/open5gs/releases/tag/v${finalAttrs.version}";
  };
})
