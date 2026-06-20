{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  mpv,
  wayland,
  libxkbcommon,
  libglvnd,
}:

rustPlatform.buildRustPackage {
  pname = "murale";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "brenton-keller";
    repo = "murale";
    rev = "8461aace00fbda96fbf3e988b314e9dbef1e1a4d"; # There are no tags yet as of writing
    hash = "sha256-UUHIboFU4aES1zQ2RwuG4dIFSiVpyhy3+WVgbbCEteo=";
  };

  cargoHash = "sha256-+jlkV+umcbHpPYbwdx0qrzuMkxA7RkSQ2BoYy0xEkck=";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    mpv
    wayland
    libxkbcommon
    libglvnd
  ];

  meta = {
    description = "Lean, memory-safe video wallpaper player for Wayland compositors ";
    homepage = "https://github.com/brenton-keller/murale";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "murale";
    maintainers = with lib.maintainers; [ Username404-59 ];
  };
}
