{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "monocle";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "bgpkit";
    repo = "monocle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z+0YKohmgSNnGtw6yDTrLsx4Q5LFOOyIUt0ji0x18BQ=";
  };

  cargoHash = "sha256-h/FWi+LmGObU6FEOC0yNRhN8wQS6UzYN7Gxe9YO8fos=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # require internet access
  checkFlags = map (t: "--skip=${t}") [
    "lens::country::tests::test_all"
    "lens::country::tests::test_lookup_by_code"
    "lens::country::tests::test_lookup_by_name"
    "lens::country::tests::test_lookup_code"
    "lens::country::tests::test_search_with_args"
    "lens::ip::tests::test_fetch_ip_info"
    "lens::search::tests::test_build_broker_with_filters"
    "lens::search::tests::test_pagination_logic"
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
