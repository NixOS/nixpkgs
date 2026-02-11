{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  openssl,
  expat,
  pkg-config,
  check,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libstrophe";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "strophe";
    repo = "libstrophe";
    rev = finalAttrs.version;
    hash = "sha256-53O8hHyw9y0Bzs+BpGouAxuSGJxh6NSNNWZqi7RHAsY=";
  };

  patches = [
    # Newer GCC rejects implicitly weak-typed pointer casting.
    # Upstream PR: https://github.com/strophe/libstrophe/pull/267
    ./pointer-cast.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    openssl
    expat
    libtool
    check
    zlib
  ];

  dontDisableStatic = true;

  strictDeps = true;

  doCheck = true;

  meta = {
    description = "Simple, lightweight C library for writing XMPP clients";
    longDescription = ''
      libstrophe is a lightweight XMPP client library written in C. It has
      minimal dependencies and is configurable for various environments. It
      runs well on both Linux, Unix, and Windows based platforms.
    '';
    homepage = "https://strophe.im/libstrophe/";
    changelog = "https://github.com/strophe/libstrophe/blob/${finalAttrs.src.rev}/ChangeLog";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      devhell
      flosse
    ];
  };
})
