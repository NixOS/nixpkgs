{
  fetchFromGitHub,
  gitUpdater,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "lucida-downloader";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jelni";
    repo = "lucida-downloader";
    tag = "v${version}";
    hash = "sha256-9wXnxsgZZprUez3PggBWbTU/Vx7JFkNC7fuOiqWG87Y=";
  };

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  cargoHash = "sha256-OfnCKFWUxpFu6NU4MNMCimXAbhspBf1n6Qz5ff7MHI4=";

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
