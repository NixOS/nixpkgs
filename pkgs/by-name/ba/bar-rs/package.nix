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
  playerctl,
  pulseaudio,
  wayland,
  wireplumber,
}:

rustPlatform.buildRustPackage rec {
  pname = "bar-rs";
  version = "unstable-2025-05-05";

  src = fetchFromGitHub {
    owner = "faervan";
    repo = "bar-rs";
    rev = "3bafbe05fee87d84366dbcb5ae305c7b6fafd5ba";
    sha256 = "sha256-eU59jYEkJJ9so7xXSgesPgWLzPVMBGa8B4RPe4EoGl8=";
  };

  cargoHash = "sha256-bmFTiH7620i+E16++nlJ1tyGCK2Jx0kzd5lHg4WrcgU=";

  nativeBuildInputs = [
    coreutils
    pkg-config
    playerctl
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
      --prefix PATH : "${lib.makeBinPath [ playerctl ]}"
  '';

  meta = {
    description = "A simple status bar for hyprland, niri and wayfire, written in rust using iced-rs";
    homepage = "https://github.com/faervan/bar-rs";
    license = lib.licenses.gpl3;
    mainProgram = "bar-rs";
    maintainers = with lib.maintainers; [ yanganto ];
  };
}
