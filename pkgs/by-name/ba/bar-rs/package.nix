{
  coreutils,
  dbus,
  fetchFromGitHub,
  lib,
  libudev-zero,
  libxkbcommon,
  makeWrapper,
  openssl,
  pkg-config,
  pulseaudio,
  rustPlatform,
  wayland,
  wireplumber,
}:

rustPlatform.buildRustPackage rec {
  pname = "bar-rs";
  version = "0-unstable-2025-11-09";

  src = fetchFromGitHub {
    owner = "faervan";
    repo = "bar-rs";
    rev = "691a59fac54ff9917dc6eb7598da8ac7273604ee";
    hash = "sha256-B/viUVC3OtgQB62WYLIyxFqzEJdDFwjlytG9wO9DD2I=";
  };

  cargoHash = "sha256-z9yM5iaHVLLD1c6QbiFzSPeY29UJEenRO/vK/wpeo4w=";

  nativeBuildInputs = [
    coreutils
    makeWrapper
    pkg-config
    pulseaudio
    wireplumber
  ];

  buildInputs = [
    dbus
    libudev-zero
    libxkbcommon
    openssl
    pkg-config
    wayland
  ];

  postFixup = ''
    wrapProgram "$out/bin/bar-rs" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
  '';

  meta = {
    description = "Status bar for hyprland, niri and wayfire, written in rust using iced-rs";
    homepage = "https://github.com/faervan/bar-rs";
    license = lib.licenses.gpl3;
    mainProgram = "bar-rs";
    maintainers = with lib.maintainers; [ yanganto ];
  };
}
