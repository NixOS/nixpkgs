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

stdenv.mkDerivation rec {
  pname = "libstrophe";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "strophe";
    repo = "libstrophe";
    rev = version;
    hash = "sha256-53O8hHyw9y0Bzs+BpGouAxuSGJxh6NSNNWZqi7RHAsY=";
  };

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

  meta = with lib; {
    description = "Simple, lightweight C library for writing XMPP clients";
    longDescription = ''
      libstrophe is a lightweight XMPP client library written in C. It has
      minimal dependencies and is configurable for various environments. It
      runs well on both Linux, Unix, and Windows based platforms.
    '';
    homepage = "https://strophe.im/libstrophe/";
    changelog = "https://github.com/strophe/libstrophe/blob/${src.rev}/ChangeLog";
    license = with licenses; [
      gpl3Only
      mit
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [
      devhell
      flosse
    ];
  };
}
