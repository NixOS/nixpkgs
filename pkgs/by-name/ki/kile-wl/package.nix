{
  lib,
  fetchFromGitLab,
  unstableGitUpdater,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
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

  cargoHash = "sha256-HcwdUwhiSkULCevsHTnRyazNfHDvLZv44SFXKxrHxYY=";

  meta = with lib; {
    description = "Tiling layout generator for river";
    homepage = "https://gitlab.com/snakedye/kile";
    license = licenses.mit;
    platforms = platforms.linux; # It's meant for river, a wayland compositor
    maintainers = with maintainers; [ moni ];
    mainProgram = "kile";
  };
}
