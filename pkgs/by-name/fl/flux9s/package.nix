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
  version = "1.5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dgunzy";
    repo = "flux9s";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MFIqxynk1y628erWht5bsgyc7XQkTYzJytAcGjvry8w=";
  };

  cargoHash = "sha256-9iPOwmyfnAUGmI1HHgCO8wX+LvtGB1eiN8PuAKVJcw8=";

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
