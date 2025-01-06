{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "inori";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "eshrh";
    repo = "inori";
    tag = "v${version}";
    hash = "sha256-D3umpem3Vj/T/UECe0qW7+qUpPgIJcRphIniURptgGE=";
  };

  cargoHash = "sha256-37rqKr+KtSuTI7pyah3nDWYnuusDyBdXjBHSrficPcE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI Client for the Music Player Daemon (MPD)";
    homepage = "https://github.com/eshrh/inori";
    changelog = "https://github.com/eshrh/inori/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    mainProgram = "inori";
    maintainers = with lib.maintainers; [ olifloof ];
  };
}
