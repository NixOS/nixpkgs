{
  fetchCrate,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flux9s";
  version = "0.7.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-B1BZuR+ieW4/ykYl0kltM7hou7oBT9qky9MY5V43r9g=";
  };

  cargoHash = "sha256-Re+vX59uJQyQsPBJTWjj8QphxqyN/KpbcS+jzRBlyEw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    description = "K9s-inspired terminal UI for monitoring Flux GitOps resources in real-time";
    mainProgram = "flux9s";
    homepage = "https://flux9s.ca/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
