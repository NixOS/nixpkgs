{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
let
  version = "0.1.1";
in
rustPlatform.buildRustPackage {
  pname = "pid-fan-controller";
  inherit version;

  src = fetchFromGitHub {
    owner = "zimward";
    repo = "pid-fan-controller";
    rev = version;
    hash = "sha256-ALR9Qa0AhcGyc3+7x5CEG/72+bJzhaEoIvQNL+QjldY=";
  };
  cargoHash = "sha256-Y57VSheI94b43SwNCDdFvcNxzkA16KObBvzZ6ywYAyU=";

  meta = {
    description = "Service to provide closed-loop PID fan control";
    homepage = "https://github.com/zimward/pid-fan-controller";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zimward ];
    platforms = lib.platforms.linux;
    mainProgram = "pid-fan-controller";
  };
}
