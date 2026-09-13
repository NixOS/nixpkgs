{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "calcli";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Siphcy";
    repo = "calcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WQHuOzSPrRU/tw1bYZj2JKLTqRyHdSJxtBB89OJ6Q6o=";
  };

  cargoHash = "sha256-XMpYNeu24cQ9dYpmNYwFqFZ54xx4WcYO2jDq0WpEiSQ=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight TUI scientific calculator with Vi-style keybindings";
    homepage = "https://github.com/Siphcy/calcli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siphcy ];
    mainProgram = "calcli";
  };
})
