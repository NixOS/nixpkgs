{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cliqr";
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "cliqr";
    rev = "refs/tags/v${version}";
    hash = "sha256-iPNI92kCNFXRiV5NV7Yj0gznwNeFoW02yh6QLrkBYO0=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    changelog = "https://github.com/paepckehh/cliqr/releases/tag/v${version}";
    homepage = "https://paepcke.de/cliqr";
    description = "Transfer, share data & secrets via console qr codes";
    license = lib.licenses.bsd3;
    mainProgram = "cliqr";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
