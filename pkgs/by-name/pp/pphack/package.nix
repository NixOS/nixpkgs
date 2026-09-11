{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "pphack";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "pphack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nxj9W+J2e9VT6mi1Q970ejYaP75cOx/YsGcqp7ju7QQ=";
  };

  vendorHash = "sha256-2PDfq1j3z6fBp4qAHz5wy6qahr3APjto8oqeTXi01xI=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  meta = {
    description = "Client-Side Prototype Pollution Scanner";
    homepage = "https://github.com/edoardottt/pphack";
    changelog = "https://github.com/edoardottt/pphack/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pphack";
  };
})
