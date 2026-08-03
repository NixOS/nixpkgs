{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "agevault";
  version = "1.1.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ndavd";
    repo = "agevault";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uc4g1dBGIIXciTbZRi7ADfQGiGNe0447kZ+unY1L+w8=";
  };

  vendorHash = "sha256-yt4K+EcoZMJ36E5qolZdbDoeWp1WhVzppVx6nDrFq2s=";
  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    homepage = "https://github.com/ndavd/agevault";
    changelog = "https://github.com/ndavd/agevault/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ ndavd ];
    mainProgram = "agevault";
    description = "Directory encryption tool using age file encryption";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
