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
  # codex-acp 0.13.0 pins openai/codex rust-v0.128.0 in Cargo.lock.
  codexRev = "e4310be51f617f5e60382038fa9cbf53a2429ca4";
  codexHash = "sha256-v2W0eslPOPHxHX76+bnkE/f4y+MnQuopeOoAC5X16TA=";
  codexSrc = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = codexRev;
    hash = codexHash;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex-acp";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Mz3xPhGSjaucZ9c0etGOe4JJC8vJhGFOnAhkwXmhyY=";
  };

  cargoHash = "sha256-kneMay6MGXhHA0q/usKsLFs/YKmdSHmrgSthzhaPgbk=";

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
