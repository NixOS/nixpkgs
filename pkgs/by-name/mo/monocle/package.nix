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
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "bgpkit";
    repo = "monocle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HJb6Lae42XOMm6AEZrDRB7JT3Qr0128MibBfMpUEiAc=";
  };

  cargoHash = "sha256-ph4z6XLFp8cO8FANFeDmoqaPfPQr5N4g3/Lwr3UrWL4=";

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
