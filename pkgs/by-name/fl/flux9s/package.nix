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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "dgunzy";
    repo = "flux9s";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kwUoA5NTjJjCI3aUgpFOcDpRZbDEPCTzzsk7TxVn6K4=";
  };

  cargoHash = "sha256-5UOaIbaAlBufB4BJ+ZX82xaKTQ4qDDRZWaweM8d2AOY=";

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
