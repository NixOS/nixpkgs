{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "lucida-downloader";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "jelni";
    repo = "lucida-downloader";
    tag = "v${version}";
    hash = "sha256-IO9X9JlLfc2UeOTnWQE73OcgWdYl03W8PuILOBFdXIg=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-Vy9kmkzwcX5VwZuDnnFyDkaGbadVR2RTs6faliq0WZ0=";

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
