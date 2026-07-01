{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lepton-jpeg-util";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "lepton_jpeg_rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G46++ZRHdfaSElt9LwI1keDXXE2/VKH2m9+EY+QNOK4=";
  };

  cargoHash = "sha256-jO+LHoZKn0RORKRw5GIwO8kBoQMjvBrofRYN33OHm/I=";

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
