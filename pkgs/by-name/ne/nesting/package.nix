{
  lib,
  stdenv,
  # Need macOS 15+ for nested virtualization.
  apple-sdk_15,
  buildGoModule,
  fetchFromGitLab,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "nesting";
  version = "0.3.0";

  src = fetchFromGitLab {
    group = "gitlab-org";
    owner = "fleeting";
    repo = "nesting";
    tag = "v${version}";
    hash = "sha256-ejoLld1TmwaqTlSyuzyEVEqLyEehu6g7yc0H0Cvkqp4=";
  };

  vendorHash = "sha256-CyXlK/0VWMFlwSfisoaNCRdknasp8faN/K/zdyRhAQQ=";

  subPackages = [ "cmd/nesting" ];

  # See https://gitlab.com/gitlab-org/fleeting/nesting/-/blob/v0.3.0/Makefile?ref_type=tags#L22-24.
  #
  # Needed for "nesting version" to not show "dev".
  ldflags = [
    "-X gitlab.com/gitlab-org/fleeting/nesting.NAME=nesting"
    "-X gitlab.com/gitlab-org/fleeting/nesting.VERSION=v${version}"
    "-X gitlab.com/gitlab-org/fleeting/nesting.REVISION=${src.rev}"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

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
    badPlatforms = [
      # Only supports AArch64 for Darwin.
      "x86_64-darwin"
    ];
  };
}
