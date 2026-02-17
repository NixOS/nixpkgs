{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "monocle";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bgpkit";
    repo = "monocle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F7z8WZAj00dYfawUiCTLnipkut9QAnXiO8DgIhJ/78U=";
  };

  cargoHash = "sha256-+XdOvjQJkeDBH/3XtMX0SCGyji10UgnSme4oZuhwiq8=";

  # require internet access
  checkFlags = map (t: "--skip=${t}") [
    "datasets::as2org::tests::test_crawling"
    "datasets::ip::tests::test_fetch_ip_info"
    "datasets::rpki::validator::tests::test_bgp"
    "datasets::rpki::validator::tests::test_list_asn"
    "datasets::rpki::validator::tests::test_list_prefix"
    "datasets::rpki::validator::tests::test_validation"
    "filters::search::tests::test_build_broker_with_filters"
    "filters::search::tests::test_pagination_logic"
    "lens::country::tests::test_all"
    "lens::country::tests::test_lookup_by_code"
    "lens::country::tests::test_lookup_by_name"
    "lens::country::tests::test_lookup_code"
    "lens::country::tests::test_search_with_args"
    "lens::ip::tests::test_fetch_ip_info"
    "lens::search::tests::test_build_broker_with_filters"
    "lens::search::tests::test_pagination_logic"
    "server::handlers::country::tests::test_country_lens_lookup"
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
