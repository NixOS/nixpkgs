{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "lucida-downloader";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "jelni";
    repo = "lucida-downloader";
    tag = "v${version}";
    hash = "sha256-/T3iB2DbcIbdwROzyB4UqXqrF7soRPCW7EUjZ8orhf4=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-GHEGz7m/IDtPaynDPQQ9Zq3wDKe4BV+H+rrF6G4QA6s=";

  meta = {
    description = "Multithreaded client for downloading music for free with lucida";
    homepage = "https://github.com/jelni/lucida-downloader";
    license = lib.licenses.gpl3Plus;
    mainProgram = "lucida";
    maintainers = with lib.maintainers; [
      surfaceflinger
    ];
  };
}
