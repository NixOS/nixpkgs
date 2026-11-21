{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gnutls,
  ldns,
  libuv,
  nghttp2,
  dohSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flamethrower";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "DNS-OARC";
    repo = "flamethrower";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5L9Unt6EXOhvPltUMQXtwJyrQhRnb1XfxIB9s+WYg6Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gnutls
    ldns
    libuv
  ]
  ++ lib.optionals dohSupport [
    nghttp2
  ];

  mesonFlags = [
    (lib.mesonBool "doh" dohSupport)
  ];

  meta = {
    description = "DNS performance and functional testing utility";
    longDescription = ''
      Flamethrower is a small, fast, configurable tool for functional testing,
      benchmarking, and stress testing DNS servers and networks. It supports
      IPv4, IPv6, UDP, TCP, DoT, and DoH and has a modular system for
      generating queries used in the tests.
    '';
    homepage = "https://github.com/DNS-OARC/flamethrower";
    changelog = "https://github.com/DNS-OARC/flamethrower/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cpu ];
    mainProgram = "flame";
    platforms = lib.platforms.unix;
  };
})
