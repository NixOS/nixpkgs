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
  version = "0.10.11";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dHw1imeAenwa1/+bgcpS9LUs59UlJDS5LAujoIabVH0=";
  };

  vendorHash = "sha256-gHfE924uFXtSyRbt2uxK+1/lU04aC1wCgoHWJ3gE7xo=";

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
