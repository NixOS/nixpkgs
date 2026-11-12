{
  fetchFromGitHub,
  lib,
  libpcap,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "netwatch-tui";
  version = "0.39.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "netwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ToLWFEf6eD3JU5GBUyLcSZmVNokky0sxeOHAgH1x85I=";
  };

  cargoHash = "sha256-iqaLDCnar/bSg4BXyftTx9kHKr4hn5SlPSED28KrpQ0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpcap ];

  doInstallCheck = true;
  nativeCheckInputs = [ versionCheckHook ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real-time network diagnostics in your terminal.";
    homepage = "https://www.netwatchlabs.com/labs/netwatch";
    changelog = "https://github.com/matthart1983/netwatch/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "netwatch";
    maintainers = with lib.maintainers; [ tomasrivera ];
  };
})
