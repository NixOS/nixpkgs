{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lpx";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "lpx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YFMGj+1WvYHWTzxtssS0PCH/1y+m+Qf5KsUuW4ETYt0=";
  };

  cargoHash = "sha256-iIAy3E4mn/AwmjMy7UnRhcsyVx7Wr+PrTTHibxMh/y0=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal Animated GIF Viewer";
    homepage = "https://github.com/lusingander/lpx";
    changelog = "https://github.com/lusingander/lpx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "lpx";
  };
})
