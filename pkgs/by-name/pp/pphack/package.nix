{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "pphack";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "pphack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IiCs8cmaQ9Y/JsDIUUMin6WH9+q7yAWYx0OXVwgh/XE=";
  };

  vendorHash = "sha256-wqRpQxSwJ8a32Q72QxWYVPuPhQZP1upEPCZnbZy6Evo=";

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
