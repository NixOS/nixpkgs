{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  libcap,
  bubblewrap,
  librusty_v8 ? callPackage ./librusty_v8.nix { },
}:
let
  # codex-acp 0.16.0 pins openai/codex rust-v0.137.0 in Cargo.lock.
  codexRev = "f221438b691b8f749d98f22077c93ebe01923fbe";
  codexHash = "sha256-puszZqi1lZeq8iXWAD9U9+WMnNvzMYKf6wVT9mtjSUU=";
  codexSrc = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = codexRev;
    hash = codexHash;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex-acp";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LeD3nHvRWX4ZgZ3/fVngDcR6/LtaY4eb2M2WmWaymlY=";
  };

  cargoHash = "sha256-ea3XyOaSshvv3oD4rm37nE76ABTbSv1y/s7HX2fqNRk=";

  # fetchCargoVendor only keeps the individual git crate subtrees. Older Codex
  # crates included this workspace-root file from codex-core.
  postPatch = ''
    if [ -e ${codexSrc}/codex-rs/node-version.txt ]; then
      cp ${codexSrc}/codex-rs/node-version.txt "$cargoDepsCopy/source-git-0/node-version.txt"
    fi
  '';

  env = {
    RUSTY_V8_ARCHIVE = librusty_v8;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    CODEX_BWRAP_SOURCE_DIR = "${bubblewrap.src}";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
  ];

  doCheck = false;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/zed-industries/codex-acp";
    changelog = "https://github.com/zed-industries/codex-acp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tlvince ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    mainProgram = "codex-acp";
  };
})
