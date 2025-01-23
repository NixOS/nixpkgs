{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "inori";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "eshrh";
    repo = "inori";
    tag = "v${version}";
    hash = "sha256-yd1kIlPepVbeTEFzjxTDWEh8o4m6dh/ya9GitqYHHT8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qGlDelNYIBbNzeD0AEYh8JrsrfpZGyfXX5mGi+ds2JI=";

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
