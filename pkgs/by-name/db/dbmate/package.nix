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
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K5aMBIJmU5vRuRihrqqMsxNXlemFwBqIfC0jVK1j87o=";
  };

  vendorHash = "sha256-47UycctApQqi9PZc3a+qKdRsG+qj46RzcCUbyNxgXiI=";

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
