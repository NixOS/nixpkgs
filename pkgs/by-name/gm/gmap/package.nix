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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "seeyebe";
    repo = "gmap";
    tag = finalAttrs.version;
    hash = "sha256-L+Dv2B+ZbGW2loh7yOMwk4x5kRFaCc+n5FgAfCSbh3M=";
  };

  cargoHash = "sha256-awdNb81j7Zhh3aIMJh1d8LuZ8rlfBe0shk/GyNb1aiA=";

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
