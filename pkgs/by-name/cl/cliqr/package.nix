{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "cliqr";
  version = "0.1.31";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "cliqr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AEUtPmLzNDsO39zRah1ln077w1S6ldsV8SsKStfQOlI=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/cliqr/releases/tag/v${finalAttrs.version}";
    homepage = "https://paepcke.de/cliqr";
    description = "Transfer, share data & secrets via console qr codes";
    license = lib.licenses.bsd3;
    mainProgram = "cliqr";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
