{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "monocle";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "bgpkit";
    repo = "monocle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-64oa3rmPR1PFmtGti1LVubO+2lY4VIkdMBKP6/IeyFk=";
  };

  cargoHash = "sha256-rSvq+aHI5u0W1RG3JQooljeDmxTHE9ywdPguHdV3T+c=";

  # require internet access
  checkFlags = [
    "--skip=datasets::as2org::tests::test_crawling"
    "--skip=datasets::ip::tests::test_fetch_ip_info"
    "--skip=datasets::rpki::validator::tests::test_bgp"
    "--skip=datasets::rpki::validator::tests::test_list_asn"
    "--skip=datasets::rpki::validator::tests::test_list_prefix"
    "--skip=datasets::rpki::validator::tests::test_validation"
    "--skip=filters::search::tests::test_build_broker_with_filters"
    "--skip=filters::search::tests::test_pagination_logic"
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
