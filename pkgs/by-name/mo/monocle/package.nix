{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "monocle";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "bgpkit";
    repo = "monocle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vpGCYU/vW4cQFuAWxa+ZkuKLB4NSs5tPW2iWVE8iPAk=";
  };

  cargoHash = "sha256-1wouA1REbPHm/v4ZB76gfgDPweNV3nztf6XxKdu42GQ=";

  # require internet access
  checkFlags = [
    "--skip=datasets::as2org::tests::test_crawling"
    "--skip=datasets::ip::tests::test_fetch_ip_info"
    "--skip=datasets::rpki::validator::tests::test_bgp"
    "--skip=datasets::rpki::validator::tests::test_list_asn"
    "--skip=datasets::rpki::validator::tests::test_list_prefix"
    "--skip=datasets::rpki::validator::tests::test_validation"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "See through all BGP data with a monocle";
    homepage = "https://github.com/bgpkit/monocle";
    changelog = "https://github.com/bgpkit/monocle/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "monocle";
  };
})
