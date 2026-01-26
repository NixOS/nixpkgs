{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "lucida-downloader";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jelni";
    repo = "lucida-downloader";
    tag = "v${version}";
    hash = "sha256-f5cegAucJSiRekTAZBkrdn0HoEELvINN6Rd5Ehb7InA=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-ADo0AuMsvd86ytlVStBXPJ9vFG/JeSm2kDMGM5VCqzA=";

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
