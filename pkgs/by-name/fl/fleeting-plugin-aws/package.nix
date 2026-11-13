{
  lib,
  buildGoModule,
  fetchFromGitLab,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "fleeting-plugin-aws";
  version = "1.3.2";

  src = fetchFromGitLab {
    owner = "gitlab-org/fleeting/plugins";
    repo = "aws";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qpWqoycF8VOHpW8Wz+W0fSL4XdDvIiVcu9NNOyuCkrA=";
  };

  vendorHash = "sha256-Cr0vOb2Hs+Wvrgsoapns2QtgPu+MdhI8fWC/UPHTHZU=";

  # Needed for "fleeting-plugin-aws -version" to not show "dev".
  #
  # https://gitlab.com/gitlab-org/fleeting/plugins/aws/-/blob/v1.0.0/Makefile?ref_type=tags#L20-22
  ldflags =
    let
      ldflagsPackageVariablePrefix = "gitlab.com/gitlab-org/fleeting/plugins/aws";
    in
    [
      "-X ${ldflagsPackageVariablePrefix}.NAME=fleeting-plugin-aws"
      "-X ${ldflagsPackageVariablePrefix}.VERSION=${finalAttrs.version}"
      "-X ${ldflagsPackageVariablePrefix}.REFERENCE=v${finalAttrs.version}"
    ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "-version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "GitLab fleeting plugin for AWS";
    homepage = "https://gitlab.com/gitlab-org/fleeting/plugins/aws";
    license = lib.licenses.mit;
    mainProgram = "fleeting-plugin-aws";
    maintainers = with lib.maintainers; [ commiterate ];
  };
})
