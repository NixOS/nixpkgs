{
  lib,
  buildGoModule,
  fetchFromGitLab,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "fleeting-plugin-aws";
  version = "1.0.0";

  src = fetchFromGitLab {
    owner = "gitlab-org/fleeting/plugins";
    repo = "aws";
    tag = "v${version}";
    hash = "sha256-8vEduf+xh9R3+GoouXJS2h/ELlzKXDmLBLekaXGn7SE=";
  };

  vendorHash = "sha256-bfEzPPP280peOK4Jyu1fyfFCaFnRLoPmsjJ+G1BoVW4=";

  subPackages = [ "cmd/fleeting-plugin-aws" ];

  # See https://gitlab.com/gitlab-org/fleeting/plugins/aws/-/blob/v1.0.0/Makefile?ref_type=tags#L20-22.
  #
  # Needed for "fleeting-plugin-aws version" to not show "dev".
  ldflags =
    let
      # See https://gitlab.com/gitlab-org/fleeting/plugins/aws/-/blob/v1.0.0/Makefile?ref_type=tags#L14.
      #
      # Couldn't find a way to substitute "go list ." into "ldflags".
      ldflagsPackageVariablePrefix = "gitlab.com/gitlab-org/fleeting/plugins/aws";
    in
    [
      "-X ${ldflagsPackageVariablePrefix}.NAME=fleeting-plugin-aws"
      "-X ${ldflagsPackageVariablePrefix}.VERSION=v${version}"
      "-X ${ldflagsPackageVariablePrefix}.REVISION=${src.rev}"
    ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgram = "${builtins.placeholder "out"}/bin/fleeting-plugin-aws";

  versionCheckProgramArg = "version";

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
}
