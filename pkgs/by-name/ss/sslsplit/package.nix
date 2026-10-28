{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  openssl,
  libevent,
  libpcap,
  libnet,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sslsplit";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "droe";
    repo = "sslsplit";
    rev = finalAttrs.version;
    sha256 = "1p43z9ln5rbc76v0j1k3r4nhvfw71hq8jzsallb54z9hvwfvqp3l";
  };

  patches = [
    (fetchpatch {
      name = "fix-openssl-3-build.patch";
      url = "https://github.com/droe/sslsplit/commit/e17de8454a65d2b9ba432856971405dfcf1e7522.patch";
      hash = "sha256-sEwP7f2PSqXdMqLub9zrfQgH8I4oe9klVPzNpJjrPJ8=";
    })
  ];

  buildInputs = [
    openssl
    libevent
    libpcap
    libnet
    zlib
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "OPENSSL_BASE=${lib.getDev openssl}"
    "LIBEVENT_BASE=${lib.getDev libevent}"
    "LIBPCAP_BASE=${lib.getDev libpcap}"
    "LIBNET_BASE=${lib.getDev libnet}"
  ];

  meta = {
    description = "Transparent SSL/TLS interception";
    homepage = "https://www.roe.ch/SSLsplit";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ contrun ];
    license = with lib.licenses; [
      bsd2
      mit
      unlicense
      free
    ];
    mainProgram = "sslsplit";
  };
})
