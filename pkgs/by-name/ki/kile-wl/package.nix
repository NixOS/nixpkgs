{
  lib,
  fetchFromGitLab,
  unstableGitUpdater,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "kile-wl";
  version = "2.1-unstable-2023-07-23";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = "kile";
    rev = "c24208761d04e0a74d203fc1dcd2f7fed68da388";
    hash = "sha256-4iclNVd7nm6LkgvsHwWaWyi1bZL/A+bbT5OSXn70bLs=";
  };

  passthru.updateScript = unstableGitUpdater {
    url = "https://gitlab.com/snakedye/kile.git";
    tagPrefix = "v";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "kilexpr-0.1.0" = "sha256-Bw6vYtzhheAJ8NLQtr3gLjZ9/5ajuABURRYDnVF9W1Y=";
    };
  };

  meta = with lib; {
    description = "Tiling layout generator for river";
    homepage = "https://gitlab.com/snakedye/kile";
    license = licenses.mit;
    platforms = platforms.linux; # It's meant for river, a wayland compositor
    maintainers = with maintainers; [ moni ];
    mainProgram = "kile";
  };
}
