{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lepton-jpeg-util";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "lepton_jpeg_rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DfVgQGGnrOOa/UdkYHSENbtxkbR0cTe08uglUM2hfGI=";
  };

  cargoHash = "sha256-AryHUFB6EWSUvKs+lBI16+A27VfRsr6aUtrwsiZxT28=";

  buildAndTestSubdir = "util";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Port of DropBox Lepton compression to Rust";
    changelog = "https://github.com/microsoft/lepton_jpeg_rust/releases/tag/v${finalAttrs.version}";
    mainProgram = "lepton_jpeg_util";
    homepage = "https://github.com/microsoft/lepton_jpeg_rust";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ skohtv ];
  };
})
