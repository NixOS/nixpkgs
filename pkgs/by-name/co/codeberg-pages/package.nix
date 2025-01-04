{
  lib,
  fetchFromGitea,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "codeberg-pages";
  version = "6.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Codeberg";
    repo = "pages-server";
    rev = "v${version}";
    hash = "sha256-VZIrg6Hzn9yP9zdOPGx6HOK64XHeX5xc52hZXwmuMKA=";
  };

  vendorHash = "sha256-pBCVkuCuyUxla6+uZM3SWXApBpMv0rFORP4tffXkuF4=";

  postPatch = ''
    # disable httptest
    rm server/handler/handler_test.go
  '';

  ldflags = [
    "-s"
    "-w"
    "-X"
    "codeberg.org/codeberg/pages/server/version.Version=${version}"
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
