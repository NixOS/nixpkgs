{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  asciidoc,
  zlib,
  jansson,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "jose";
  version = "14";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "jose";
    rev = "v${version}";
    hash = "sha256-rMNPJaCtVpbwIkMQzBNpmRct6S/NelTwjmsuB0RP6R8=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    asciidoc
  ];
  buildInputs = [
    zlib
    jansson
    openssl
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];
  enableParallelBuilding = true;

  meta = {
    description = "C-language implementation of Javascript Object Signing and Encryption";
    mainProgram = "jose";
    homepage = "https://github.com/latchset/jose";
    maintainers = [ ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
