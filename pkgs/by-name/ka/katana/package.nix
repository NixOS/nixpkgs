{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "katana";
  version = "1.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LJufz8KXFKai9Ntdc7/zpblS8xQTzbiEWruFVCu59m4=";
  };

  vendorHash = "sha256-1QfmMsgbsrUwRd7ZAgvhwsRCuae3Pc5MYb+p59AsRU4=";

  subPackages = [ "cmd/katana" ];

  ldflags = [ "-s" ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckKeepEnvironment = [ "HOME" ];

  doInstallCheck = true;

  meta = {
    description = "Next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "katana";
  };
})
