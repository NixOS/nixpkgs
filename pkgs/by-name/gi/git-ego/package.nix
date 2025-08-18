{
  lib,
  gitMinimal,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "git-ego";
  version = "0.2.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bgreenwell";
    repo = "git-ego";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6TWDvil4VhP5/vHFNWBUMLYkJL/wAZEIJXKz2u884n0=";
  };

  vendorHash = "sha256-95hogC0JlrnUJBvoV4Ac4F5XmOqsQh2AQ0rZGcC/4oY=";

  ldflags = [ "-s" ];

  nativeCheckInputs = [ gitMinimal ];

  checkFlags = [ "--skip=TestIntegration_FullWorkflow" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Git identity manager and automatic profile switcher";
    longDescription = ''
      Your Git identity manager and automatic profile switcher.
      Seamlessly manage user profiles, SSH keys, and tokens across
      different repositories.
    '';
    homepage = "https://github.com/bgreenwell/git-ego";
    changelog = "https://github.com/bgreenwell/git-ego/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "git-ego";
  };
})
