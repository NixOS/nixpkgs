{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pretty-make";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "awea";
    repo = "pretty-make";
    tag = finalAttrs.version;
    hash = "sha256-hk2Z9bWnBUZP2wXADpCX9KUIE8zbUcW2hTP1a4VKTEM=";
  };

  cargoHash = "sha256-8pGXDqAokeD+lu8Ve2+nXcZ+DGQq+gzTeZK1qnYBC+k=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Parse a Makefile to produce a pretty help";
    homepage = "https://github.com/awea/pretty-make";
    changelog = "https://github.com/Awea/pretty-make/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "pretty-make";
  };
})
