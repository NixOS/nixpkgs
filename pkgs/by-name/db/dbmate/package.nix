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
  version = "2.38.1";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XKeft6c1gyD0atrjURDkuW4JI1B7/jh0q/ccfsbzj7w=";
  };

  vendorHash = "sha256-p2J9lpTIvTItCTQG9Q4MNA78267oQC0PNgb+Saor+5Q=";

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
