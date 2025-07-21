{
  lib,
  fetchFromGitea,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "codeberg-pages";
  version = "6.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Codeberg";
    repo = "pages-server";
    rev = "v${version}";
    hash = "sha256-5+4yKcXyKSg7Q2h7W3G6AYkIOmYA4D4DDjdLK57lwdw=";
  };

  vendorHash = "sha256-EefUX5MEQrJGtUbX/bINcMSJQjnnLzKQt04hENY8G2E=";

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

  meta = {
    mainProgram = "pages";
    maintainers = with lib.maintainers; [
      laurent-f1z1
      christoph-heiss
    ];
    license = lib.licenses.eupl12;
    homepage = "https://codeberg.org/Codeberg/pages-server";
    description = "Static websites hosting from Gitea repositories";
    changelog = "https://codeberg.org/Codeberg/pages-server/releases/tag/v${version}";
  };
}
