{
  lib,
  stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  libx11,
  libxi,
  libpulseaudio,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asciipat";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "msokalski";
    repo = "ascii-patrol";
    tag = finalAttrs.version;
    hash = "sha256-0AuZE9s8BJ6QflF0vZ9BN707sT0k/mWc8QYlUAu2lII=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libx11
    libxi
    libpulseaudio
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ASCII terminal game inspired by Moon Patrol";
    homepage = "https://github.com/msokalski/ascii-patrol";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "asciipat";
    maintainers = with lib.maintainers; [ Joey574 ];
  };
})
