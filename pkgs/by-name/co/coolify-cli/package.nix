{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "coolify-cli";
  version = "1.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "coollabsio";
    repo = "coolify-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i6ikBckrKERWJ8GcgqXQ3/oU0C0TJ40UOC5WOT7zJWs=";
  };

  vendorHash = "sha256-stWvIJJDZifJBelF/5DVapGY10HAnMROJcbadqkqBIA=";

  subPackages = [ "coolify" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-X github.com/coollabsio/coolify-cli/internal/version.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "CLI for managing Coolify instances";
    homepage = "https://github.com/coollabsio/coolify-cli";
    changelog = "https://github.com/coollabsio/coolify-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jonocodes ];
    mainProgram = "coolify";
  };
})
