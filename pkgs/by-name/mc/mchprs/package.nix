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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "MCHPR";
    repo = "MCHPRS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jm9ZsqCKOIxZsXQbCluYu7MgOD7hXYljcv/URaNVUW0=";
  };

  cargoHash = "sha256-YDfyixNfJsKigf3W5265CWl4ETQDeBHYpquBoFoj4Tw=";

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
