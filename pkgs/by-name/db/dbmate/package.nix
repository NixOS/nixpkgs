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
  version = "2.29.3";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H/HBDM2uBRrlgetU2S9ZS1c6//Le+DlrYlnnJpTs3XM=";
  };

  vendorHash = "sha256-wfcVb8fqnpT8smKuL6SPANAK86tLXglhQPZCA4G8P9E=";

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
