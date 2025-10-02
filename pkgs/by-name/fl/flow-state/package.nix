{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "flow_state";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Stan-breaks";
    repo = pname;
    rev = "v1.0.3";
    hash = "sha256-7j8W370lr/QaLL+T7N/2SlcrPe+dTW5zlNPL7+U/Vog=";
  };

  cargoHash = "sha256-IY4Kd43zLIGRjQbkeZddl6ayRv997HuSKV1DKI8Z6BY=";

  meta = with lib; {
    description = "A terminal-based habit tracker designed for neurodivergent users";
    mainProgram = "flow_state";
    homepage = "https://github.com/Stan-breaks/flow_state";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      overloader
    ];
  };
}
