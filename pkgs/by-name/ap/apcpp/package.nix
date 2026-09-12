{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ixwebsocket,
  jsoncpp,
  openssl,
  zlib,
}:

stdenv.mkDerivation {
  pname = "apcpp";
  version = "0-unstable-2026-08-25";

  src = fetchFromGitHub {
    owner = "N00byKing";
    repo = "APCpp";
    rev = "172f683d4306b4fa209949419993198f87d881ed";
    hash = "sha256-kcVZQlKl6DVWKkOxnduv+XezISYP1q8YKkClS/rmn1M=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ixwebsocket
    jsoncpp
    openssl
    zlib
  ];

  patches = [ ./prefer-system-version-of-ixwebsocket.patch ];

  meta = {
    description = "C++ Library for Clients interfacing with the Archipelago Multi-Game Randomizer";
    homepage = "https://github.com/N00byKing/APCpp";
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21Plus;
  };
}
