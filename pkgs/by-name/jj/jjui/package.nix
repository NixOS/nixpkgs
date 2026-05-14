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
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3cr6aSJoIAv9Ine2ePHCC6xBaS1G4i23yQh8I5mq47g=";
  };

  vendorHash = "sha256-iUWeQIYwOkXhRFsQc5zBjFFG5m412ysR5LsZsHET1ak=";

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
