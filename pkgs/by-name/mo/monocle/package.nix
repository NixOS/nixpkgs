{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  pkg-config,
  aws-lc,
  sqlite,
  zstd,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "monocle";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "bgpkit";
    repo = "monocle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rib6T4zonSwzOaDfSP6TQaSOmkr2Tr2HzB5ystf2D8E=";
  };

  cargoHash = "sha256-LWVFzIx28kE805DOU8U8qrGJsqN40PUfRqm6umR9Wbs=";

  env = {
    AWS_LC_SYS_USE_SYSTEM = true;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    aws-lc
    sqlite
    zstd
  ];

  nativeCheckInputs = [
    cacert
    writableTmpDirAsHomeHook
  ];

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

  __darwinAllowLocalNetworking = true;

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
