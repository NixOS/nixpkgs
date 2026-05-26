{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "pphack";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "pphack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bXasbIiJGBNsrEWNy/q33UnrjwC1mUV1BO2S8qkrWHo=";
  };

  vendorHash = "sha256-RZJXl2GC9vJq5Ui9hlyKEkiq9HeMQeJIvsH6tOUp4Sg=";

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
