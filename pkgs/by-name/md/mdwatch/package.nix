{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdwatch";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "vimlinuz";
    repo = "mdwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h2ZUcvRkCxvVZWIroyzLGkzW4B3+iMCU5GRvIcNTrWk=";
  };

  cargoHash = "sha256-03qTW1NuNEzU6krG2S9C/9sCB6U9nM3nu4isdPR+3Aw=";

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Simple CLI tool to live-preview Markdown files in your browser";
    homepage = "https://github.com/vimlinuz/mdwatch";
    changelog = "https://github.com/vimlinuz/mdwatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "mdwatch";
  };
})
