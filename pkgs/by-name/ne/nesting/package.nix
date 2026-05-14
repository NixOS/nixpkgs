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

buildGoModule (finalAttrs: {
  pname = "nesting";
  version = "0.5.0";

  src = fetchFromGitLab {
    owner = "gitlab-org/fleeting";
    repo = "nesting";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cdn01R1Jr2npqeKrA8CiC6r85LNfQvq0EONrmMPY0ds=";
  };

  vendorHash = "sha256-PjsS+lTEuReA+alzZsrx6c7JIPaZldgGi/a/Xh4k5w4=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  # Needed for "nesting version" to not show "dev".
  #
  # https://gitlab.com/gitlab-org/fleeting/nesting/-/blob/v0.3.0/Makefile?ref_type=tags#L22-24
  ldflags =
    let
      ldflagsPackageVariablePrefix = "gitlab.com/gitlab-org/fleeting/nesting";
    in
    [
      "-X ${ldflagsPackageVariablePrefix}.NAME=nesting"
      "-X ${ldflagsPackageVariablePrefix}.VERSION=${finalAttrs.version}"
      "-X ${ldflagsPackageVariablePrefix}.REFERENCE=v${finalAttrs.version}"
    ];

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
})
