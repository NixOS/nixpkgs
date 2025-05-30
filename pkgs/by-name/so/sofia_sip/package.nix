{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  glib,
  openssl,
  pkg-config,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "sofia-sip";
  version = "1.13.17";

  src = fetchFromGitHub {
    owner = "freeswitch";
    repo = "sofia-sip";
    rev = "v${version}";
    sha256 = "sha256-7QmK2UxEO5lC0KBDWB3bwKTy0Nc7WrdTLjoQYzezoaY=";
  };

  patches = [
    # Fix build with gcc 14 from https://github.com/freeswitch/sofia-sip/pull/249
    (fetchpatch2 {
      name = "sofia-sip-fix-incompatible-pointer-type.patch";
      url = "https://github.com/freeswitch/sofia-sip/commit/46b02f0655af0a9594e805f09a8ee99278f84777.diff";
      hash = "sha256-4uZVtKnXG+BPW8byjd7tu4uEZo9SYq9EzTEvMwG0Bak=";
    })
  ];

  buildInputs = [
    glib
    openssl
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = with lib; {
    description = "Open-source SIP User-Agent library, compliant with the IETF RFC3261 specification";
    homepage = "https://github.com/freeswitch/sofia-sip";
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}
