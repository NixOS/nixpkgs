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
  version = "2.33.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qdW7hutxjdhT8ypQOmVrcTMzuySy0zkS8SeTbvaGVK4=";
  };

  vendorHash = "sha256-kKj3KOWq1IeQcR2/QJYsKZh6Kxryj0y687CKzyeO4ZM=";

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
