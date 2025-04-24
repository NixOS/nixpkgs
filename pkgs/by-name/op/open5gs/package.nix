{
  stdenv,
  nodejs,
  buildNpmPackage,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open5gs";
  version = "2.7.2";

  diameter = fetchFromGitHub {
    owner = "open5gs";
    repo = "freeDiameter";
    rev = "20196a265aecb7b1573ceb526bb619e092c1fd3f"; # r1.5.0
    hash = "sha256-0sxzQtKBx313+x3TRsmeswAq90Vk5jNA//rOJcEZJTQ=";
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
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-XSDjVW+5l2trrilKMcSfX6QIfh/ijWxjoJg33Bn1DBU=";
  };

  webui = buildNpmPackage {
    pname = finalAttrs.pname + "-webui";
    inherit (finalAttrs) src version meta;

    sourceRoot = "${finalAttrs.src.name}/webui";

    npmDepsHash = "sha256-IpqineYa15GBqoPDJ7RpaDsq+MQIIDcdq7yhwmH4Lzo=";

    installPhase = ''
      rm -rf node_modules
      mkdir $out
      cp -r * $out
    '';
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
    lksctp-tools
    libidn
    openssl
    curl
    libtins
    gnutls
    libnghttp2.dev
  ];

  # For subproject
  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=array-bounds"
      "-Wno-error=stringop-overflow"
    ];
  };

  preConfigure = ''
    cp -R --no-preserve=mode,ownership ${finalAttrs.diameter} subprojects/freeDiameter
    cp -R --no-preserve=mode,ownership ${finalAttrs.libtins} subprojects/libtins
    cp -R --no-preserve=mode,ownership ${finalAttrs.promc} subprojects/prometheus-client-c

    rm -rf webui/*
    cp -r ${finalAttrs.webui}/* webui/
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
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    changelog = "https://github.com/open5gs/open5gs/releases/tag/v${finalAttrs.version}";
  };
})
