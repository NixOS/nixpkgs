{
  lib,
  fetchFromGitea,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "codeberg-pages";
  version = "5.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Codeberg";
    repo = "pages-server";
    rev = "v${version}";
    hash = "sha256-txWRYQnJCGVZ0/6pZdKkRFsdUe2B+A0Fy0/WJCiBVa0=";
  };

  vendorHash = "sha256-0JPnBf4NA4t+63cNMZYnB56y93nOc8Wn7TstRiHgvhk=";

  postPatch = ''
    # disable httptest
    rm server/handler/handler_test.go
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  tags = [
    "sqlite"
    "sqlite_unlock_notify"
    "netgo"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    mainProgram = "pages";
    maintainers = with maintainers; [
      laurent-f1z1
      christoph-heiss
    ];
    license = licenses.eupl12;
    homepage = "https://codeberg.org/Codeberg/pages-server";
    description = "Static websites hosting from Gitea repositories";
    changelog = "https://codeberg.org/Codeberg/pages-server/releases/tag/v${version}";
  };
}
