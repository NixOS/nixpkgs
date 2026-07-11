{
  lib,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hacksguard";
  version = "0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Rhacknarok";
    repo = "hacksguard";
    tag = finalAttrs.version;
    hash = "sha256-kS8VF1zD4VV9rSLz4euvNwtOUFWLeW2isAjgjw/iay0=";
  };

  cargoHash = "sha256-7Wt2cFKwWT82P2uxOy/lGEWZcCUSu0BNr9JdgRLwBnw=";

  nativeBuildInputs = [ pkg-config ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-threaded TUI malware analysis tool";
    homepage = "https://github.com/Rhacknarok/hacksguard";
    changelog = "https://github.com/Rhacknarok/hacksguard/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "hacksguard";
  };
})
