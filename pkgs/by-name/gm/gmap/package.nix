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
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "seeyebe";
    repo = "gmap";
    tag = finalAttrs.version;
    hash = "sha256-+klVySOgI/M57f98Cx3omkEBx/NcaWD4FuIW6cz1aN8=";
  };

  cargoHash = "sha256-WjYCwGyFjBjITqsMPsD4kkeuSGPXtSKOFKaEfznMryI=";

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
    homepage = "https://github.com/seeyebe/gmap";
    changelog = "https://github.com/seeyebe/gmap/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gmap";
  };
})
