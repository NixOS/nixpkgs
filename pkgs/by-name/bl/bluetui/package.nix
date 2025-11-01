{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage rec {
  pname = "bluetui";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "bluetui";
    rev = "v${version}";
    hash = "sha256-ifEodPcUaFwH53xLNYZWSnMqGKF79QClyS8xjVEqtkg=";
  };

  cargoHash = "sha256-BKdXcZDvwvKMA5snFstbmQKmtcGQEzXBctz7+6Vp2xQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  meta = {
    description = "TUI for managing bluetooth on Linux";
    homepage = "https://github.com/pythops/bluetui";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "bluetui";
    platforms = lib.platforms.linux;
  };
}
