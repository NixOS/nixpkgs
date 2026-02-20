{
  rustPlatform,
  lib,
  fetchFromGitHub,
  dbus,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iio-niri";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Zhaith-Izaliel";
    repo = "iio-niri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tbCiG/u350U7UbYDV5gWczDQd//RosNHuzB/cP9Dyyo=";
  };

  cargoHash = "sha256-JnjBnqZXRhxUClvC2hIW898AwwEOS/ELrsrjY2dV3Is=";

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
})
