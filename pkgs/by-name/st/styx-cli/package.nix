{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "styx-cli";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "bearcove";
    repo = "styx";
    tag = "styx-cli-v${finalAttrs.version}";
    hash = "sha256-uvOUKbJUTDy9ejJI47Zl3JYi8YNISWWeC/IBjxRK47U=";
  };

  postPatch = ''
    patchShebangs ./scripts
  '';

  cargoHash = "sha256-9HJ6snG4+naBa2c0j+hAXUNnaEfzTaLZ7eU/XYCiCSQ=";

  cargoBuildFlags = [
    "--package"
    "styx-cli"
  ];

  useNextest = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex"
      "styx-cli-v(.*)"
    ];
  };

  meta = {
    changelog = "https://github.com/bearcove/styx/releases/tag/styx-cli-v${finalAttrs.version}";
    description = "Document language for mortals";
    downloadPage = "https://github.com/bearcove/styx";
    homepage = "https://styx.bearcove.eu/";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.pyrox0 ];
    mainProgram = "styx";
  };
})
