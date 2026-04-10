{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.15.1";

  src = fetchFromGitHub {
    repo = "oauth2-proxy";
    owner = "oauth2-proxy";
    sha256 = "sha256-4PuyX+BbaL1q66LVtLADkOFj1oq49sERmz0igtyOKB8=";
    rev = "v${version}";
  };

  vendorHash = "sha256-PB0x4tRBx6U5ZulFYD16AdH2kHCfse8BEJXuiQCFq3I=";

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  ldflags = [ "-X github.com/oauth2-proxy/oauth2-proxy/v7/pkg/version.VERSION=v${version}" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Reverse proxy that provides authentication with Google, Github, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = lib.licenses.mit;
    mainProgram = "oauth2-proxy";
    maintainers = with lib.maintainers; [
      swarsel
    ];
  };
}
