{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "aimssh";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "sairash";
    repo = "aimssh";
    tag = finalAttrs.version;
    hash = "sha256-MNFVpUqBY+7l2TMJBIE8WT/mbRclkJe8UMtVdsQa760=";
  };

  vendorHash = "sha256-5yDkvMvqm3p3RUPLc/kv9B6YNrc5tDulrhqsLSA4xSs=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SSH Pomodoro";
    homepage = "https://github.com/sairash/aimssh";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "aimssh";
  };
})
