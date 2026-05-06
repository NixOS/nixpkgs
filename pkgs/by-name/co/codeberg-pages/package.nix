{
  lib,
  fetchFromCodeberg,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "codeberg-pages";
  version = "6.4";

  src = fetchFromCodeberg {
    owner = "Codeberg";
    repo = "pages-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xNsob0fW6SaqVKBIgRFj0YZUymHKWWfWZ5UqGkHWOmA=";
  };

  vendorHash = "sha256-nSFUBIO3ssnwVHcjHRgUWjIK+swZP9PEJOTwM7esIgo=";

  postPatch = ''
    # disable httptest
    rm server/handler/handler_test.go
  '';

  ldflags = [
    "-s"
    "-w"
    "-X"
    "codeberg.org/codeberg/pages/server/version.Version=${finalAttrs.version}"
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
      christoph-heiss
    ];
    license = lib.licenses.eupl12;
    homepage = "https://codeberg.org/Codeberg/pages-server";
    description = "Static websites hosting from Gitea repositories";
    changelog = "https://codeberg.org/Codeberg/pages-server/releases/tag/v${finalAttrs.version}";
  };
})
