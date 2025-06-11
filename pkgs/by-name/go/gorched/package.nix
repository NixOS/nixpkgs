{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "gorched";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "zladovan";
    repo = "gorched";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cT6wkWUlz3ixv7Mu5143I5NxjfwhKQ6bLwrW3BwTtTQ=";
  };
  vendorHash = "sha256-9fucarQKltIxV8j8L+yQ6Fa7IRIhoQCNxcG21KYOpuw=";

  postPatch = ''
    mkdir ./cmd/gorched
    mv ./cmd/main.go ./cmd/gorched/main.go
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = ''Terminal based game written in Go inspired by "The Mother of all games" Scorched Earth'';
    homepage = "https://github.com/zladovan/gorched";
    changelog = "https://github.com/zladovan/gorched/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "gorched";
  };
})
