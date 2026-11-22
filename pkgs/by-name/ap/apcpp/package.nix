{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ixwebsocket,
  openssl,
  cmake,
  jsoncpp,
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

  patches = [
    ./use-system-ixwebsocket.patch
  ];

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ixwebsocket
    zlib
    jsoncpp
    openssl
  ];

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/N00byKing/APCpp";
    description = "C++ Library for Clients interfacing with the Archipelago Multi-Game Randomizer";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ mysaa ];
  };
}
