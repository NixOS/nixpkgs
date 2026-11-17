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
  version = "0.30.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "netwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pzkg7ME7qtAddeV9OIPwrbPqvQPOad11ryMui5Ma1xU=";
  };

  cargoHash = "sha256-Kj4sE9zuZIhorNwQcqmAcLGZuonzq8cfYyo91HWD/Tw=";

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
