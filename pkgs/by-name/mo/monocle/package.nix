{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "monocle";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "bgpkit";
    repo = "monocle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jXjIhAryTD+XpbekBmO2WnzNlCuHAD6VMVv6mB79WEg=";
  };

  cargoHash = "sha256-m7Cb1KZUUcOqlVerKkjXx/RrlAfxTk6NmopJT1x+Htg=";

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
    "--skip=lens::country::tests::test_all"
    "--skip=lens::country::tests::test_lookup_by_code"
    "--skip=lens::country::tests::test_lookup_by_name"
    "--skip=lens::country::tests::test_lookup_code"
    "--skip=lens::country::tests::test_search_with_args"
    "--skip=lens::ip::tests::test_fetch_ip_info"
    "--skip=lens::search::tests::test_build_broker_with_filters"
    "--skip=lens::search::tests::test_pagination_logic"
    "--skip=server::handlers::country::tests::test_country_lens_lookup"
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
