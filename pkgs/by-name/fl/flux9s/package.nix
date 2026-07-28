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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dgunzy";
    repo = "flux9s";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DpXTWnFjQ023cWEe46Qu+m200vVNnraSq7RNVcr9GxM=";
  };

  cargoHash = "sha256-R3dEHn6XY+6q6kZcp43T/ASGiEIqvtlORRJ9VOgW9f0=";

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
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
