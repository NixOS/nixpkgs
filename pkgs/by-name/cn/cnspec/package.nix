{
  lib,
  buildGoModule,
  fetchFromGitHub,
  getent,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "cnspec";
  version = "13.38.1";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I05Ud0aYvWmKsBq68G0jze0rqxYPnZUunLGEUHVQThQ=";
  };

  proxyVendor = true;

  vendorHash = "sha256-4ZhjlQqgf2k9KQ8GA4ZoFFl7KyH/zgGYTQwPJhKRsoo=";

  subPackages = [ "apps/cnspec" ];

  nativeInstallCheckInputs = [
    getent
    writableTmpDirAsHomeHook
    versionCheckHook
  ];

  ldflags = [
    "-s"
    "-X=go.mondoo.com/cnspec/v${(lib.versions.major finalAttrs.version)}.Version=${finalAttrs.version}"
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
