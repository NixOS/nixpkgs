{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  stdenv,
}:
buildGo125Module (finalAttrs: {
  pname = "jjui";
  version = "0.10.9";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D/ZBH9bsiWO26+xxixD8RKgnoA3x74YdYAIoRznsBTQ=";
  };

  vendorHash = "sha256-BldmFVYpRPdnyeswPKGspH4oZ2mjvFS5VbTu3DN5bJg=";

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-skip=TestServerAskpass"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for Jujutsu VCS";
    homepage = "https://github.com/idursun/jjui";
    changelog = "https://github.com/idursun/jjui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      adamcstephens
      adda
    ];
    mainProgram = "jjui";
  };
})
