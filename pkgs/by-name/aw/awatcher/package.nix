{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  libxkbcommon,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "awatcher";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "2e3s";
    repo = "awatcher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wxnbyWkfRFN+aWa7rrSIv5PdNHNU/D/w7y/VIwzxxaI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    libxkbcommon
  ];
  doCheck = false;

  cargoHash = "sha256-/dI0gaTRElAQnZNRo2sKMUc33fphubcG/fXOflPHXWs=";

  meta = {
    description = "Activity and idle watchers";
    longDescription = ''
      Awatcher is a window activity and idle watcher with an optional tray and UI for statistics. The goal is to compensate
      the fragmentation of desktop environments on Linux by supporting all reportable environments, to add more
      flexibility to reports with filters, and to have better UX with the distribution by a single executable.
    '';
    downloadPage = "https://github.com/2e3s/awatcher/releases";
    homepage = "https://github.com/2e3s/awatcher";
    license = lib.licenses.mpl20;
    mainProgram = "awatcher";
    maintainers = [ lib.maintainers.aikooo7 ];
    platforms = lib.platforms.linux;
  };
})
