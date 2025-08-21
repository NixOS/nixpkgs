{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "gorched";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "zladovan";
    repo = "gorched";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n4MKZqhgAIsgK9XPv2pF8mK0I4suSN02JkqY7Aj+LG0=";
  };
  vendorHash = "sha256-ohFj0jEHt0SV3pC9+mz+XAjOJ6MIBFY7CJf+G++r72U=";

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
