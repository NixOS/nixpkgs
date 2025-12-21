{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "agevault";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "ndavd";
    repo = "agevault";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f7t/hzBfZi3OJtYPM4n5bDhm+LcceinDUZIpVsSSl/s=";
  };

  vendorHash = "sha256-jiSYg4+RLzezW1D1kWxmNoEn0rlbXRzU3BsK16aP0tw=";
  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    homepage = "https://github.com/ndavd/agevault";
    changelog = "https://github.com/ndavd/agevault/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ srghma ];
    mainProgram = "agevault";
    description = "Directory encryption tool using age file encryption";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
