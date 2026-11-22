{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codediff-watcher";
  version = "0.28.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "esmuellert";
    repo = "codediff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kI/dGVlKc0XcAViCP8kzuqE90YEaKZ1eJsncV0esEtw=";
  };

  cargoHash = "sha256-gQKJPoZdV9XtFHbove8NXZEGdwaJQDVeZfrgtYd2iIA=";

  buildAndTestSubdir = "crates/watcher";

  nativeCheckInputs = [ git ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native repository watcher for codediff.nvim";
    homepage = "https://github.com/esmuellert/codediff";
    license = lib.licenses.mit;
    mainProgram = "codediff-watcher";
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
