{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "pphack";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "pphack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SVoIFrdiuFQDrqfqo+edXGXSMXEbmdecoHn8LzPuMUE=";
  };

  vendorHash = "sha256-zrC+QNv6Tat7rMsPbVAkbqT6WEImgGg5XSgIN3xSd2w=";

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
