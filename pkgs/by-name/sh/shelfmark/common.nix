{
  lib,
  fetchFromGitHub,
}:
let
  version = "1.2.0";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "calibrain";
    repo = "shelfmark";
    tag = "v${version}";
    hash = "sha256-t4t7je7Y/aezx/EX7paJIcsCq5qyZeU/+mPLeZ8oTPg=";
  };

  meta = {
    description = "Self-hosted web interface for searching and downloading books and audiobooks";
    homepage = "https://github.com/calibrain/shelfmark";
    changelog = "https://github.com/calibrain/shelfmark/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
    mainProgram = "shelfmark";
  };
}
