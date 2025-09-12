{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "mchprs";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "MCHPR";
    repo = "MCHPRS";
    tag = "v${version}";
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

  meta = with lib; {
    mainProgram = "mchprs";
    description = "Multithreaded Minecraft server built for redstone";
    homepage = "https://github.com/MCHPR/MCHPRS";
    license = licenses.mit;
    maintainers = with maintainers; [ gdd ];
  };
}
