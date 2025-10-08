{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "jjui";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UkgQ3uxWPwLQiNhcZReFifLPD8h+xmH798ckTtia/+4=";
  };

  vendorHash = "sha256-VfzvGzh/ZYHI5LDuhwOwb4nEOVesBu0kxRF6Q/ISPww=";

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

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
      adda
    ];
    mainProgram = "jjui";
  };
})
