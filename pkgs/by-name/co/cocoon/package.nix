{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "cocoon";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "haileyok";
    repo = "cocoon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pRtfYW3mojOycUaky4y+fcbGaeXAjj1jO1ewwFamGO8=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-5WnME+AVrXfvHX2yPbFoL6QgZoCMAJmBj47OM7miOfc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ATProtocol Personal Data Server written in Go with a SQLite block and blob store";
    changelog = "https://github.com/haileyok/cocoon/releases/v${finalAttrs.version}";
    homepage = "https://github.com/haileyok/cocoon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "cocoon";
  };
})
