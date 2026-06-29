{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rido";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lj3954";
    repo = "rido";
    rev = "a731341207d5886b43322a0f5b46692ad9a2a739";
    hash = "sha256-VQldNVyDoKCqfUVjuhZj4dOcmxUSK446XtpgDg6G0CY=";
  };

  cargoHash = "sha256-2bfODjw+JHrX8kHvr09+DGV1Ntvt9aacSdyVZlvQc/g=";

  meta = {
    description = "Fetch valid URLs and checksums of Microsoft Operating Systems";
    homepage = "https://github.com/lj3954/rido";
    license = lib.licenses.gpl3Plus;
    mainProgram = "rido";
    maintainers = with lib.maintainers; [ stv0g ];
  };
})
