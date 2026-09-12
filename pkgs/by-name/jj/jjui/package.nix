{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  stdenv,
}:
buildGo127Module (finalAttrs: {
  pname = "jjui";
  version = "0.10.10";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bNwWbQq76RztLIiu/uYtHwRvg6H3x59ASCiFRKBib04=";
  };

  vendorHash = "sha256-T+uv54h89ul0O30HXsngUAIEEfD52bS+zZagCpn8JBU=";

  excludedPackages = [
    # docker-based pty tests
    "e2e"
  ];

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
