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

stdenv.mkDerivation (finalAttrs: {
  pname = "jose";
  version = "15";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "jose";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zfwo4axQuCKHtP7W3qacZqoo+Dkp5q4RKW34HeBxgOQ=";
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
    # The last successful Darwin Hydra build was in 2024
    broken = stdenv.hostPlatform.isDarwin;
  };
})
