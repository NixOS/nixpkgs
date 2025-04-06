{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "cliqr";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "cliqr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JM5sWVby8dSFz2YtNXgU9z5fc6EI5nnxmpQN/71kdjI=";
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
