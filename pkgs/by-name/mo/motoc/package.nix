{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openxr-loader,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "motoc";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "motoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j3Ti2YnZGTkiqC32jnaBaWQ+g4L9+ZiSbanfUxdqMN4=";
  };

  cargoHash = "sha256-fQFuKqcDqqtsh4GxoBuFF6gyd6mV5PjCntPbCdQU41A=";

  buildInputs = [
    openxr-loader
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MOnado Tracking Origin Calibration program";
    homepage = "https://github.com/galister/motoc";
    changelog = "https://github.com/galister/motoc/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pandapip1 ];
    mainProgram = "motoc";
  };
})
