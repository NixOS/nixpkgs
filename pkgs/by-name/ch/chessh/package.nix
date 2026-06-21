{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "chessh";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "rasjonell";
    repo = "chessh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QRHNFTmfefg/sXC44RrMkdiwUcD6/J4UuMokawJpkdA=";
  };

  vendorHash = "sha256-EwzDuMLfHqHmLOM48PQttVBVvuJ+r9mXr6FYkOZScZk=";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SSH into a chess game";
    homepage = "https://github.com/rasjonell/chessh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "chessh";
  };
})
