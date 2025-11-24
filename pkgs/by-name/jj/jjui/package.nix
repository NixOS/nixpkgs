{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "jjui";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sLOQa9IoRcYEXcShiE/vdjJknQcDwefVwHii63MPXpw=";
  };

  vendorHash = "sha256-SMeS1FHc8UdXaxF9A8eYFkWQIM0hgWfBpuX+DsBglcw=";

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
