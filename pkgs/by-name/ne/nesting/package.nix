{
  lib,
  # Need macOS 15+ for nested virtualization.
  apple-sdk_15,
  buildGoModule,
  fetchFromGitLab,
  nix-update-script,
  stdenv,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "nesting";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "gitlab-org/fleeting";
    repo = "nesting";
    tag = "v${version}";
    hash = "sha256-ejoLld1TmwaqTlSyuzyEVEqLyEehu6g7yc0H0Cvkqp4=";
  };

  vendorHash = "sha256-CyXlK/0VWMFlwSfisoaNCRdknasp8faN/K/zdyRhAQQ=";

  subPackages = [ "cmd/nesting" ];

  # See https://gitlab.com/gitlab-org/fleeting/nesting/-/blob/v0.3.0/Makefile?ref_type=tags#L22-24.
  #
  # Needed for "nesting version" to not show "dev".
  ldflags =
    let
      # See https://gitlab.com/gitlab-org/fleeting/nesting/-/blob/v0.3.0/Makefile?ref_type=tags#L18.
      #
      # Couldn't find a way to substitute "go list ." into "ldflags".
      ldflagsPackageVariablePrefix = "gitlab.com/gitlab-org/fleeting/nesting";
    in
    [
      "-X ${ldflagsPackageVariablePrefix}.NAME=nesting"
      "-X ${ldflagsPackageVariablePrefix}.VERSION=v${version}"
      "-X ${ldflagsPackageVariablePrefix}.REVISION=${src.rev}"
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgram = "${builtins.placeholder "out"}/bin/nesting";

  versionCheckProgramArg = "version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Basic and opinionated daemon that sits in front of virtualization platforms";
    homepage = "https://gitlab.com/gitlab-org/fleeting/nesting";
    license = lib.licenses.mit;
    mainProgram = "nesting";
    maintainers = with lib.maintainers; [ commiterate ];
  };
}
