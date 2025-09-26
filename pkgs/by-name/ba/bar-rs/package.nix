{
  lib,
  rustPlatform,
  fetchFromGitHub,
  coreutils,
  libudev-zero,
  libxkbcommon,
  makeWrapper,
  openssl,
  pkg-config,
  pulseaudio,
  wayland,
  wireplumber,
}:

rustPlatform.buildRustPackage rec {
  pname = "bar-rs";
  version = "0-unstable-2025-08-02";

  src = fetchFromGitHub {
    owner = "faervan";
    repo = "bar-rs";
    rev = "ebe8363cb173f6d4e0bb5d1396486c684a0a1008";
    hash = "sha256-Kl6UYOElb+V9wdQ8CqprghgQREiK6VPM/50S7dCtafY=";
  };

  cargoHash = "sha256-bmFTiH7620i+E16++nlJ1tyGCK2Jx0kzd5lHg4WrcgU=";

  nativeBuildInputs = [
    coreutils
    pkg-config
    pulseaudio
    wayland
    wireplumber
    makeWrapper
  ];

  buildInputs = [
    libudev-zero
    libxkbcommon
    openssl
    pkg-config
  ];

  # Insert Nix-built `wayland` into LD_LIBRARY_PATH
  # because the dependency Iced crate need it
  postFixup = ''
    wrapProgram "$out/bin/bar-rs" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}" \
  '';

  meta = {
    description = "Status bar for hyprland, niri and wayfire, written in rust using iced-rs";
    homepage = "https://github.com/faervan/bar-rs";
    license = lib.licenses.gpl3;
    mainProgram = "bar-rs";
    maintainers = with lib.maintainers; [ yanganto ];
  };
}
