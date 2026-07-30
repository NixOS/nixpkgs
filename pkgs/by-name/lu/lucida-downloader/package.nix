{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lucida-downloader";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "jelni";
    repo = "lucida-downloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-284f3+yKkE37wZzmyW7qupvYwEkmLvco8lc5dFSiLAQ=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-PT8E9AqvhChKk76AA2qsAf2ICy5maQ9SK96V/vkmwy8=";

  meta = {
    description = "Multithreaded client for downloading music for free with lucida";
    homepage = "https://github.com/jelni/lucida-downloader";
    license = lib.licenses.agpl3Plus;
    mainProgram = "lucida";
    maintainers = with lib.maintainers; [
      jelni
      surfaceflinger
    ];
  };
})
