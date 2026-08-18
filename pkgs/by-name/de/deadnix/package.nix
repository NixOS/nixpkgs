{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deadnix";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "astro";
    repo = "deadnix";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Lx49eqWINMTi3jgacSUHQ0SAU7jWlqaO2ZMrER+Bd/A=";
  };

  cargoHash = "sha256-MX4McxCeUQ1stk33BSm/zITHaXqOJUwNMfMVISgfMFA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = lib.licenses.gpl3Only;
    mainProgram = "deadnix";
    maintainers = with lib.maintainers; [
      astro
      diogotcorreia
    ];
  };
})
