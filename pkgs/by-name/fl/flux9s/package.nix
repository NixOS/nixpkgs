{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flux9s";
  version = "1.0.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dgunzy";
    repo = "flux9s";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fue1f/I10Jtrfa2AwiC6fLHItF/KFQvLfM/Ukr3TVi4=";
  };

  cargoHash = "sha256-sHK4Qrl8y0B3QpGIqgdjbn7DqWozGSqFLI/tE38cQlw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "K9s-inspired terminal UI for monitoring Flux GitOps resources in real-time";
    mainProgram = "flux9s";
    homepage = "https://flux9s.ca/";
    changelog = "https://github.com/dgunzy/flux9s/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
