{
  useLua ? true,
  usePcre ? true,
  withPrometheusExporter ? true,
  sslLibrary ? "openssl",
  stdenv,
  lib,
  fetchurl,
  nixosTests,
  zlib,
  libxcrypt,
  aws-lc,
  libressl,
  openssl,
  wolfssl,
  lua5_4,
  pcre2,
}:

assert lib.assertOneOf "sslLibrary" sslLibrary [
  "aws-lc"
  "libressl"
  "openssl"
  "wolfssl"
];
let
  sslPkgs = {
    inherit
      aws-lc
      libressl
      openssl
      ;
    wolfssl = wolfssl.override {
      variant = "haproxy";
      extraConfigureFlags = [ "--enable-quic" ];
    };
  };
  sslPkg = sslPkgs.${sslLibrary};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "haproxy";
  version = "3.3.0";

  src = fetchurl {
    url = "https://www.haproxy.org/download/${lib.versions.majorMinor finalAttrs.version}/src/haproxy-${finalAttrs.version}.tar.gz";
    hash = "sha256-vy2mtp+C17hVvpd6ueHUcE7vVim2V6xyr7WVioackC4=";
  };

  buildInputs = [
    sslPkg
    zlib
    libxcrypt
  ]
  ++ lib.optional useLua lua5_4
  ++ lib.optional usePcre pcre2;

  # TODO: make it work on bsd as well
  makeFlags = [
    "PREFIX=${placeholder "out"}"
    (
      "TARGET="
      + (
        if stdenv.hostPlatform.isSunOS then
          "solaris"
        else if stdenv.hostPlatform.isLinux then
          "linux-glibc"
        else if stdenv.hostPlatform.isDarwin then
          "osx"
        else
          "generic"
      )
    )
  ];

  buildFlags = [
    "USE_ZLIB=yes"
    "USE_OPENSSL=yes"
    "SSL_INC=${lib.getDev sslPkg}/include"
    "SSL_LIB=${lib.getDev sslPkg}/lib"
    "USE_QUIC=yes"
  ]
  ++ lib.optionals (sslLibrary == "aws-lc") [
    "USE_OPENSSL_AWSLC=true"
  ]
  ++ lib.optionals (sslLibrary == "openssl" && lib.versionOlder openssl.version "3.5.2") [
    "USE_QUIC_OPENSSL_COMPAT=yes"
  ]
  ++ lib.optionals (sslLibrary == "wolfssl") [
    "USE_OPENSSL_WOLFSSL=yes"
  ]
  ++ lib.optionals usePcre [
    "USE_PCRE2=yes"
    "USE_PCRE2_JIT=yes"
  ]
  ++ lib.optionals useLua [
    "USE_LUA=yes"
    "LUA_LIB_NAME=lua"
    "LUA_LIB=${lua5_4}/lib"
    "LUA_INC=${lua5_4}/include"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "USE_GETADDRINFO=1"
  ]
  ++ lib.optionals withPrometheusExporter [
    "USE_PROMEX=yes"
  ]
  ++ [ "CC=${stdenv.cc.targetPrefix}cc" ];

  enableParallelBuilding = true;

  passthru.tests.haproxy = nixosTests.haproxy;

  meta = {
    changelog = "https://www.haproxy.org/download/${lib.versions.majorMinor finalAttrs.version}/src/CHANGELOG";
    description = "Reliable, high performance TCP/HTTP load balancer";
    homepage = "https://haproxy.org";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Only
    ];
    longDescription = ''
      HAProxy is a free, very fast and reliable solution offering high
      availability, load balancing, and proxying for TCP and HTTP-based
      applications. It is particularly suited for web sites crawling under very
      high loads while needing persistence or Layer7 processing. Supporting
      tens of thousands of connections is clearly realistic with todays
      hardware.
    '';
    maintainers = with lib.maintainers; [ vifino ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "haproxy";
  };
})
