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
  version = "0-unstable-2025-11-19";

  src = fetchFromGitHub {
    owner = "faervan";
    repo = "bar-rs";
    rev = "497e797860b6047f5ef04fac52fd89f34f5d0b6a";
    hash = "sha256-7E/sRl7qeuuHc6F0UJ1P7C6s52v7sQTHi5C30T0o8Jc=";
  };

  cargoHash = "sha256-ll1EfZnW2+KeK8TCyn+LrLCUQCP5A0hEhhRN7b+nc8E=";

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
