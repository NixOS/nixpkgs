{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "ngrrram";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "wintermute-cell";
    repo = "ngrrram";
    rev = "v${version}";
    hash = "sha256-65cbNsGQZSpxKV0lq/Z7TK7CODPTqayOiPStukFbo44=";
  };

  cargoHash = "sha256-CWk3ixajgDI1oOOZ4qBZw5jq1xlJtxa6sAQu+fyk4rI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI tool to help you type faster and learn new layouts. Includes a free cat";
    homepage = "https://github.com/wintermute-cell/ngrrram";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Guanran928 ];
    mainProgram = "ngrrram";
  };
}
