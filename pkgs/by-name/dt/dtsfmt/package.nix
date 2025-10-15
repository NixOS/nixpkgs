{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "dtsfmt";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mskelton";
    repo = "dtsfmt";
    rev = "v${version}";
    hash = "sha256-abNHciHBhJtRfkp7nqMtTw7xIqehPZsRXa6fVnPGeJw=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-VCI4qHOpN9xRTHuoE7/+Ybbg0eAmeDD4lNoUQZxJiAE=";

  meta = {
    description = "Auto formatter for device tree files";
    homepage = "https://github.com/mskelton/dtsfmt";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "dtsfmt";
  };
}
