{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "pphack";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "pphack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SWMY+t8NzbUqAeLsqia5KAXXOjoMRMZVVa8YdTLcG5A=";
  };

  vendorHash = "sha256-smJp3GDo1KOrEjEJnxtyrlHmb/L70QqhDWjCZ4U1qJs=";

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
