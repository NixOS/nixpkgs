{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "cliqr";
  version = "0.1.29";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "cliqr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fhNMiUaCTk4xYGJRMuZCHeYvzGeVwkS7E7LU1L+LuBg=";
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
