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
  version = "0.27.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jasisz";
    repo = "aver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pP9+PBScmufBfSpaLPyG1Wn8W4U5TYm707EK3VmCPsA=";
  };

  cargoHash = "sha256-/xfEl8VN9gY8L4e5UKRT+WuLb16vRH6hQdQ47y4/3uU=";

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
