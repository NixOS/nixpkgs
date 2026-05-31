{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  pname = "sonar";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "raskrebs";
    repo = "sonar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ucOIFws3fo94o5ziJDn8ldgWkpAuiUqW8A+MQdPNy3c=";
  };

  vendorHash = "sha256-komX1AmHt2NoF1x6xsNa2RFkfVzOXfYEMPhT0zwMxjw=";

  ldflags = [
    "-s -w -X github.com/raskrebs/sonar/internal/selfupdate.Version=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "CLI tool for inspecting and managing services listening on localhost ports";
    homepage = "https://github.com/raskrebs/sonar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paepcke ];
    mainProgram = "sonar";
  };
})
