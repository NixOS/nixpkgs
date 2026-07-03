{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
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

  # These tests use tempdir + cargo metadata subprocess which fails on Darwin
  # sandboxes due to getcwd() differences (XNU vs Linux). Tracked upstream at
  # https://github.com/otter-sec/anchor/issues/4751
  checkFlags = map (t: "--skip=${t}") (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "program::tests::discover_solana_programs_finds_sibling_programs_from_nested_member"
      "program::tests::discover_solana_programs_lists_all_members_from_nested_member"
    ]
  );

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
