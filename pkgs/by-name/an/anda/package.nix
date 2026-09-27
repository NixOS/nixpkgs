{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anda";
  version = "0.8.12";

  src = fetchFromGitHub {
    owner = "FyraLabs";
    repo = "anda";
    tag = finalAttrs.version;
    hash = "sha256-LbGmWfbo+T9KvRJOkp2qWSRbxcy2QmMVs9duturc5hM=";
  };

  cargoHash = "sha256-uAuqPciRU4C8WvWsYCxvaCp/sRTrdYtviqyhqCSyZXo=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A modern Build/CI System";
    homepage = "https://github.com/FyraLabs/anda";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "anda";
  };
})
