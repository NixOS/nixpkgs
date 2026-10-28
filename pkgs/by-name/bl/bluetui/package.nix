{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bluetui";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "bluetui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gOmPWkn5RznvmxPsAJUFXYNTBoZV/v42S3w1bpZeWt0=";
  };

  cargoHash = "sha256-dWDkbje4JtGnRWsnmiLZ4GI3ZfL9cImp+9Pb+nzSyLA=";

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
    maintainers = with lib.maintainers; [
      donovanglover
      matthiasbeyer
    ];
    mainProgram = "bluetui";
    platforms = lib.platforms.linux;
  };
})
