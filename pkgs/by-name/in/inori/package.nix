{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "inori";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "eshrh";
    repo = "inori";
    tag = "v${version}";
    hash = "sha256-g+OH8sjfByrVsI1KogkluvAqNyYz7Fba2aeJkFhCgPU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YiGAOX2zxfjpLBzS7vlUlMG6cUHEAkdbm6z6P7ar064=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Client for the Music Player Daemon (MPD)";
    homepage = "https://github.com/eshrh/inori";
    changelog = "https://github.com/eshrh/inori/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    mainProgram = "inori";
    maintainers = with lib.maintainers; [
      stephen-huan
      esrh
    ];
  };
}
