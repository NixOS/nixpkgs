{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flow_state";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "Stan-breaks";
    repo = "flow_state";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7j8W370lr/QaLL+T7N/2SlcrPe+dTW5zlNPL7+U/Vog=";
  };

  cargoHash = "sha256-IY4Kd43zLIGRjQbkeZddl6ayRv997HuSKV1DKI8Z6BY=";

  meta = {
    description = "Terminal-based habit tracker designed for neurodivergent users";
    mainProgram = "flow_state";
    homepage = "https://github.com/Stan-breaks/flow_state";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      overloader
    ];
  };
})
