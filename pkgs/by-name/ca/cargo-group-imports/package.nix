{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "cargo-group-imports";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "cpg314";
    repo = "cargo-group-imports";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y4/un5Z0MdnDPfPmWXtDRxXNdIEpGAC4x+2TY//cAVs=";
  };

  patches = [
    (fetchpatch2 {
      name = "adjust-tests.patch";
      url = "https://github.com/cpg314/cargo-group-imports/commit/5816db94f9b36c4157d71f8dfa22392e718a084a.patch?full_index=1";
      hash = "sha256-gHre9i+k7sIUwNgZqNNstybeabE2+HqAPkom9mkd67Q=";
    })
    # https://github.com/cpg314/cargo-group-imports/pull/5
    (fetchpatch2 {
      name = "fixup-warning.patch";
      url = "https://github.com/cpg314/cargo-group-imports/commit/64a90b6b308950062eafcfffa975e70c2d9a6201.patch?full_index=1";
      hash = "sha256-S4QUmHPm2bDJA1GzCUaAFVJKtR0FO6ZDESiH8Xe+cMg=";
    })
  ];

  cargoHash = "sha256-r9/Lhf3vJLC+F6a4alVtdCiodV/uLLMXUjh2xx58kPg=";

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Group imports in Rust workspaces";
    homepage = "https://github.com/cpg314/cargo-group-imports";
    changelog = "https://github.com/cpg314/cargo-group-imports/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      baloo
    ];
    mainProgram = "cargo-group-imports";
  };
})
