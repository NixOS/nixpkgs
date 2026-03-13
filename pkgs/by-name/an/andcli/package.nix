{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "andcli";
  version = "2.5.0";

  subPackages = [ "cmd/andcli" ];

  src = fetchFromGitHub {
    owner = "tjblackheart";
    repo = "andcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TrcLw5pUMzyXUuMyQljVXbprS2voqvmVk6Ktj6Zi7Xk=";
  };

  vendorHash = "sha256-jtyxzmDGm/JHTJAkCHfSfECNB5XkwEyTBWnMCbCOAvE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/tjblackheart/andcli/v2/internal/buildinfo.Commit=${finalAttrs.src.tag}"
    "-X github.com/tjblackheart/andcli/v2/internal/buildinfo.AppVersion=${finalAttrs.src.tag}"
  ];

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/tjblackheart/andcli";
    description = "2FA TUI for your shell";
    changelog = "https://github.com/tjblackheart/andcli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "andcli";
  };
})
