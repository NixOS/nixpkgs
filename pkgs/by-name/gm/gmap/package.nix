{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gmap";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "marawny";
    repo = "gmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bHQjOZrY7tuyI7ScX+Hazkch4QtPD7bxc3+fy+HCVVs=";
  };

  cargoHash = "sha256-CiSt+ETQa3qVHolOo2y0wZQac8pMJZbtxqfWiEPbfM8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for visualizing Git activity";
    longDescription = ''
      gmap helps you understand your Git repository at a glance — not
      just what changed, but when, how much, and by whom. Visualize
      commit activity over time, spot churn-heavy files, explore
      contributor dynamics, and more — all from your terminal.

      Built for developers who live in the CLI and want quick,
      powerful insights.
    '';
    homepage = "https://github.com/marawny/gmap";
    changelog = "https://github.com/marawny/gmap/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gmap";
  };
})
