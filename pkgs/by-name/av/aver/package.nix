{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  lld,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aver";
  version = "0.29.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jasisz";
    repo = "aver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2KfJoPOUkHtnj3EweW0xICcS0E/X/c0lLVyaQXZjUj0=";
  };

  cargoHash = "sha256-PbzmpE6NFaR44WCLjIgNdAiEnGv2VbSsJdCL4y8P590=";

  cargoBuildFlags = [
    "--workspace"
    "--bin=aver"
    "--bin=aver-lsp"
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ lld ];

  # some tests are generated, some take a long time, some need to be skipped
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Programming language for auditable AI-written code";
    homepage = "https://github.com/jasisz/aver";
    changelog = "https://github.com/jasisz/aver/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "aver";
  };
})
