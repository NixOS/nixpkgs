{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
  cacert,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flux9s";
  version = "1.5.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dgunzy";
    repo = "flux9s";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x/klXGQm6sLhLayv0B7spEt/m5N1p/hoP/Rm+jfx+YM=";
  };

  cargoHash = "sha256-3E3Y2cgVd5DcYc7UxOPpkREw6Gxhu8ayGUPibT/LeOs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [ cacert ];

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
