{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,

  # testing
  sqlite,
}:

buildGoModule (finalAttrs: {
  pname = "dbmate";
  version = "2.37.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PlPS6bPfKjVzRxR78etDAPZxBfWcMbTCqPY5S79/XAc=";
  };

  vendorHash = "sha256-3Sc9nKNX8xWRAQ7Vtz5IEtNTs6MHVN8yoKOy+p2r7XY=";

  tags = [ "fts5" ];

  nativeCheckInputs = [
    sqlite
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Database migration tool";
    mainProgram = "dbmate";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sarahec
    ];
  };
})
