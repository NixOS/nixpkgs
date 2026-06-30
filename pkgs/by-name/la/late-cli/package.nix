{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "late-cli";
  version = "0.33.13";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mpiorowski";
    repo = "late-sh";
    tag = "v${finalAttrs.version}-cli";
    hash = "sha256-D09d4VTyb7qjW+8cQ9DUMdtp+OM47qOmyBmnFb3juHg=";
  };

  cargoHash = "sha256-JofFkvcd0SMED7RQxPYa8s4cEn55sUDD1vn+waQemm0=";

  cargoBuildFlags = [
    "--package=late-cli"
    "--bin=late"
  ];

  env.LATE_CLI_VERSION = finalAttrs.version;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex"
      "^v([0-9.]+)-cli$"
    ];
  };

  meta = {
    description = "Companion CLI for late.sh";
    longDescription = ''
      late-cli is a companion CLI for late.sh, a cozy terminal clubhouse for developers.
      It provides local audio playback, paired controls, and visualizer sync.
    '';
    homepage = "https://late.sh";
    changelog = "https://github.com/mpiorowski/late-sh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "late";
  };
})
