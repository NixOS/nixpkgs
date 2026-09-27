{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mchprs";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "MCHPR";
    repo = "MCHPRS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aNzHk2oaULADTr76ANjpKy0+aiP87MPkXmeiF9s57WE=";
  };

  cargoHash = "sha256-AklIFznwlY52CTDCcQwuedcoEOq3eegZfM37sAGwaOw=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    sqlite
    zlib
  ];

  meta = {
    mainProgram = "mchprs";
    description = "Multithreaded Minecraft server built for redstone";
    homepage = "https://github.com/MCHPR/MCHPRS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gdd ];
  };
})
