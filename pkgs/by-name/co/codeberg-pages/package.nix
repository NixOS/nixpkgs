{
  lib,
  fetchFromGitea,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "codeberg-pages";
  version = "6.2.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Codeberg";
    repo = "pages-server";
    rev = "v${version}";
    hash = "sha256-kWEwKdm/GAUtsc4ZyCn7VJm9vVWDBOHJRer2FP1L/g0=";
  };

  vendorHash = "sha256-qGjcMZhwflYdwOrGS9EApkwVLLSolQBBIeU8AU/fT/I=";

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
