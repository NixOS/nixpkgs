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
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "Zhaith-Izaliel";
    repo = "iio-niri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6kIHZuHZYDsjY0q8V99jdDkNHwNtvrq77sxGI5SLzSs=";
  };

  cargoHash = "sha256-gXqAUvZ0FjU7SrCmw0CpNtELPwmI0fFpJpe3wrBuqsY=";

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
