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
  version = "0.4.0";

  src = fetchFromGitLab {
    owner = "gitlab-org/fleeting";
    repo = "nesting";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W4Pv990X3R4ksHGfwycdTYvUfjwm5sxh0AeoG9EZ/0A=";
  };

  vendorHash = "sha256-YYHiyNg15VdijyrR5t1PwIjHWXmofHcVD6YMrbwn4Qk=";

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
