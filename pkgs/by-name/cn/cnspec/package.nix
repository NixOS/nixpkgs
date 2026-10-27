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
  version = "14.8.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RFpNtp5W3OadZwkY2sRvPSeIBl6JvQtTWDdqCw5aokI=";
  };

  proxyVendor = true;

  vendorHash = "sha256-46GaMnpXPiM8ra7LC2drUylB20VxNriYIHNeVaYA+pI=";

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
