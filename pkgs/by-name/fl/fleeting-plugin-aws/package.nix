{
  lib,
  buildGoModule,
  fetchFromGitLab,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "fleeting-plugin-aws";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "gitlab-org/fleeting/plugins";
    repo = "aws";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AN+dHI1ZLNAGAe1tVuUt6KuXUU1gDyFqEdyiOm3OCoo=";
  };

  vendorHash = "sha256-aOs3zSIvK2EUuMsh+BhD+jxHXASsetPXtm83mv7dAaA=";

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
