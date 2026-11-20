{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  getent,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGo127Module (finalAttrs: {
  pname = "cnspec";
  version = "14.12.1";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ckw0lXE4ou5y8HIXlFg6b981cIzcuAz6CQcBhZ27V+A=";
  };

  proxyVendor = true;

  vendorHash = "sha256-lk9Fc9m5VvVPM69iDaiTvUl50Z6HkkMoGsL3lWE/iuc=";

  subPackages = [ "apps/cnspec" ];

  nativeInstallCheckInputs = [
    getent
    writableTmpDirAsHomeHook
    versionCheckHook
  ];

  ldflags = [
    "-s"
    "-X=go.mondoo.com/cnspec.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  versionCheckKeepEnvironment = "HOME PATH";

  versionCheckProgramArg = [ "version" ];

  meta = {
    description = "Open source, cloud-native security and policy project";
    homepage = "https://github.com/mondoohq/cnspec";
    changelog = "https://github.com/mondoohq/cnspec/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      fab
      mariuskimmina
    ];
    mainProgram = "cnspec";
  };
})
