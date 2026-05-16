{
  fetchCrate,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flux9s";
  version = "0.9.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-cto3Fu2UW8+Pq6OK5miw+cAwzqiotTGWPD0Yyckh1/M=";
  };

  cargoHash = "sha256-uOa/qWBtTQf7jJWJhFJBmYWQ5mU/3P/YuACbnVbHdJc=";

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
