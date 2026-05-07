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
  # codex-acp 0.12.0 pins openai/codex rust-v0.124.0 in Cargo.lock.
  codexRev = "e9fb49366c93a1478ec71cc41ecee415a197d036";
  codexHash = "sha256-YFnzzwCm9/b30qLDMbkf/rEizuTjeqdCgoBZeS0wNBo=";
  codexSrc = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = codexRev;
    hash = codexHash;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex-acp";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qPqg95FpXHBtyHBJtrfJUwu9GokfmOJgKgqLKQ48u+8=";
  };

  cargoHash = "sha256-/BZ82qiTy/mPwhf5v5CFrNSB6AxCRFdmHB72L0+KjJw=";

  # fetchCargoVendor only keeps the individual git crate subtrees, so restore
  # the workspace-root file that codex-core includes via ../../../../node-version.txt.
  postPatch = ''
    cp ${codexSrc}/codex-rs/node-version.txt "$cargoDepsCopy/source-git-0/node-version.txt"
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
