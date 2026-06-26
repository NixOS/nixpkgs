{
  lib,
  stdenv,
  autoreconfHook,
  boost,
  db48,
  fetchFromGitHub,
  fetchpatch2,
  libevent,
  miniupnpc,
  openssl,
  pkg-config,
  zeromq,
  zlib,
  unixtools,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "particl-core";
  version = "23.2.9.0";

  src = fetchFromGitHub {
    owner = "particl";
    repo = "particl-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g/RNr2IxipoDlPfkzE8ou1wOTFrUYp7MuNoWklsyBjU=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    openssl
    db48
    boost
    zlib
    miniupnpc
    libevent
    zeromq
    unixtools.hexdump
    python3
  ];

  configureFlags = [
    "--disable-bench"
    "--with-boost-libdir=${boost.out}/lib"
  ]
  ++ lib.optionals (!finalAttrs.doCheck) [
    "--enable-tests=no"
  ];

  # Always check during Hydra builds
  doCheck = true;
  preCheck = "patchShebangs test";
  enableParallelBuilding = true;

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Privacy-Focused Marketplace & Decentralized Application Platform";
    longDescription = ''
      An open source, decentralized privacy platform built for global person to person eCommerce.
      RPC daemon and CLI client only.
    '';
    homepage = "https://particl.io/";
    maintainers = with lib.maintainers; [ demyanrogozhin ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
