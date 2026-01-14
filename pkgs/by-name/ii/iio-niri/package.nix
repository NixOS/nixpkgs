{
  rustPlatform,
  lib,
  fetchFromGitHub,
  dbus,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "iio-niri";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Zhaith-Izaliel";
    repo = "iio-niri";
    tag = "v${version}";
    hash = "sha256-IOMJ1xtjUkUoUgFZ9pxBf5XKdaUHu3WbUH5TlEiNRc4=";
  };

  cargoHash = "sha256-b05Jy+EKFAUcHR9+SdjHZUcIZG0Ta+ar/qc0GdRlJik=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  meta = {
    description = "Listen to iio-sensor-proxy and updates Niri output orientation depending on the accelerometer orientation";
    homepage = "https://github.com/Zhaith-Izaliel/iio-niri";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zhaithizaliel ];
    mainProgram = "iio-niri";
    platforms = lib.platforms.linux;
  };
}
