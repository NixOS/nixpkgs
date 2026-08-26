{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anchor";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "otter-sec";
    repo = "anchor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/aDNw+Up48NZZIjEKXj4M2UIbcCt766Tv0eOlFau2gQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-oEgWfklxjP8+TxrhDKJgcTsanpqJpEiHXJyir8neYj8=";

  # Upstream patch to fix cargo metadata discovery on macOS Nix sandboxes.
  # Replaces fragile subprocess-cwd approach with in-process manifest path
  # resolution. Remove on next version bump (included in v1.1.3+).
  # See: https://github.com/otter-sec/anchor/pull/4757
  patches = [
    (fetchpatch {
      url = "https://github.com/otter-sec/anchor/commit/25bf2112b67d84e5bc406d7eac2919c90d8e54ed.patch";
      hash = "sha256-q5OGNoUGPuCNHgaZNo9fmUxqQnFH2MhRW4ZefX+Of0Y=";
    })
  ];

  # Only build the anchor-cli package
  cargoBuildFlags = [
    "-p"
    "anchor-cli"
  ];

  # Only run tests for the anchor-cli
  cargoTestFlags = [
    "-p"
    "anchor-cli"
  ];

  meta = {
    description = "Solana Sealevel Framework";
    homepage = "https://github.com/otter-sec/anchor";
    changelog = "https://github.com/otter-sec/anchor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      Denommus
      _0xgsvs
    ];
    mainProgram = "anchor";
  };
})
