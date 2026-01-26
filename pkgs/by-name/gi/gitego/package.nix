{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gitego";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "bgreenwell";
    repo = "gitego";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A6LrUnGbKP8ry4cleoclrki4Z4Dm7jaPO3DyqMxr/jA=";
  };

  vendorHash = "sha256-95hogC0JlrnUJBvoV4Ac4F5XmOqsQh2AQ0rZGcC/4oY=";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags = [ "--skip=TestIntegration_FullWorkflow" ];

  # FIXME: should work but doesn't
  doInstallCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Git identity manager and automatic profile switcher";
    longDescription = ''
      Your Git identity manager and automatic profile switcher.
      Seamlessly manage user profiles, SSH keys, and tokens across
      different repositories.
    '';
    homepage = "https://github.com/bgreenwell/gitego";
    changelog = "https://github.com/bgreenwell/gitego/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gitego";
  };
})
