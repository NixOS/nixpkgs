{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  alsa-lib,
  libjack2,
}:

rustPlatform.buildRustPackage rec {
  pname = "asak";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "chaosprint";
    repo = "asak";
    rev = "v${version}";
    hash = "sha256-yhR8xLCFSmTG2yqsbiP3w8vcvLz4dsn4cbMPFedzUFI=";
  };

  cargoHash = "sha256-ssHYQhx5rNkTH6KJuJh2wPcptIcIxP8BcDNriGj3btk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    libjack2
  ];

  # There is no tests
  doCheck = false;

  meta = {
    description = "A cross-platform audio recording/playback CLI tool with TUI, written in Rust";
    homepage = "https://github.com/chaosprint/asak";
    changelog = "https://github.com/chaosprint/asak/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "asak";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
