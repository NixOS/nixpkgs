{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "girouette";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "gourlaysama";
    repo = "girouette";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CROd44lCCXlWF8X/9HyjtTjSlCUFkyke+BjkD4uUqXo=";
  };

  cargoHash = "sha256-1jRm8tKL6QTBaCjFgt+NKQjdGjJIURTb3rs1SrrKwr4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
  ];

  meta = {
    description = "Show the weather in the terminal, in style";
    homepage = "https://github.com/gourlaysama/girouette";
    changelog = "https://github.com/gourlaysama/girouette/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      linuxissuper
      cafkafk
    ];
    mainProgram = "girouette";
  };
})
