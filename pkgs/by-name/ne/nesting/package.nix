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
  version = "0.2.1";

  src = fetchFromGitLab {
    owner = "gitlab-org/fleeting";
    repo = "nesting";
    tag = "v${version}";
    hash = "sha256-6JgwzJrULbXLQI5pB5DttjOkVyN7s9Bgr/L5sD79Nvw=";
  };

  vendorHash = "sha256-JIVETis405olMyq8cvBjw4KRG9qusSfktx1vAM48y3s=";

  subPackages = [ "cmd/nesting" ];

  # See https://gitlab.com/gitlab-org/fleeting/nesting/-/blob/v0.2.1/Makefile?ref_type=tags#L22-24.
  #
  # Needed for "nesting version" to not show "dev".
  ldflags =
    let
      # See https://gitlab.com/gitlab-org/fleeting/nesting/-/blob/v0.2.1/Makefile?ref_type=tags#L18.
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
    # TODO: Find maintainer(s).
    maintainers = with lib.maintainers; [ ];
  };
}
