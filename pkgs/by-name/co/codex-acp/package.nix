{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkg-config,
  openssl,
  libcap,
}:
let
  versionData = builtins.fromJSON (builtins.readFile ./hashes.json);
  inherit (versionData)
    version
    hash
    cargoHash
    codexRev
    codexSrcHash
    nodeVersionHash
    ;

  # codex-core uses include_str!("../../../../node-version.txt"), so we need
  # to place node-version.txt at the vendored workspace root.
  nodeVersionFile = fetchurl {
    url = "https://raw.githubusercontent.com/zed-industries/codex/${codexRev}/codex-rs/node-version.txt";
    hash = nodeVersionHash;
  };

  # codex-linux-sandbox compiles a patched bubblewrap source tree from
  # codex-rs/vendor/bubblewrap. Cargo vendoring flattens workspace layout,
  # so this directory must be provided explicitly.
  codexSrc = fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex";
    rev = codexRev;
    hash = codexSrcHash;
  };
in
rustPlatform.buildRustPackage {
  pname = "codex-acp";
  inherit version;

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex-acp";
    rev = "v${version}";
    inherit hash;
  };

  inherit cargoHash;

  preBuild = ''
    cp ${nodeVersionFile} "$NIX_BUILD_TOP/codex-acp-${version}-vendor/node-version.txt"
  '';

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    CODEX_BWRAP_SOURCE_DIR = "${codexSrc}/codex-rs/vendor/bubblewrap";
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

  passthru.updateScript = ./update.py;

  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/zed-industries/codex-acp";
    changelog = "https://github.com/zed-industries/codex-acp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tlvince ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    mainProgram = "codex-acp";
  };
}
