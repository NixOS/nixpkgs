{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "openwalletstandard";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "open-wallet-standard";
    repo = "core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ARAiGgo/yjTIKy/kj/tN9xHBRpxGk7jeIiMk76gFx/I=";
  };

  sourceRoot = "${finalAttrs.src.name}/ows";
  buildAndTestSubdir = "crates/ows-cli";
  cargoHash = "sha256-b1Mo27e88l0J34PvFP5Ev0DSS76vxT/hnBbdY7Djb1M=";
  # Upstream enables the `fast-kdf` dev-only feature in tests, which fails under release-profile checks.
  checkType = "debug";

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "CLI for the Open Wallet Standard";
    homepage = "https://openwallet.sh";
    license = lib.licenses.mit;
    mainProgram = "ows";
    maintainers = with lib.maintainers; [ _0xferrous ];
  };
})
