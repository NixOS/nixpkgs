{
  rustPlatform,
  stdenv,
  lib,
  fetchFromGitHub,
  dbus,
  pkg-config,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iio-niri";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Zhaith-Izaliel";
    repo = "iio-niri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EwilbkL1cMH8l63Cm5eikVKc+YndsYsaYJxhCNJgz6M=";
  };

  cargoHash = "sha256-f/pFWlLxQebzawDdHj3UtpT5Kq9a6fm+tAssqg8ibdo=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    dbus
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd iio-niri \
      --bash <($out/bin/iio-niri completions bash) \
      --zsh <($out/bin/iio-niri completions zsh) \
      --fish <($out/bin/iio-niri completions fish)
  '';

  meta = {
    description = "Listen to iio-sensor-proxy and updates Niri output orientation depending on the accelerometer orientation";
    homepage = "https://github.com/Zhaith-Izaliel/iio-niri";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zhaithizaliel ];
    mainProgram = "iio-niri";
    platforms = lib.platforms.linux;
  };
})
