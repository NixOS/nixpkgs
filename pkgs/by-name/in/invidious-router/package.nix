{
  lib,
  buildGoModule,
  fetchFromGitLab,
  nix-update-script,
}:
let
  version = "1.2";
in
buildGoModule {
  pname = "invidious-router";
  inherit version;

  src = fetchFromGitLab {
    owner = "gaincoder";
    repo = "invidious-router";
    rev = "refs/tags/${version}";
    hash = "sha256-YcMtZq4VMHr6XqHcsAAEmMF6jF1j1wb7Lq4EK42QAEo=";
  };

  vendorHash = "sha256-c03vYidm8SkoesRVQZdg/bCp9LIpdTmpXdfwInlHBKk=";

  passthru.updateScript = nix-update-script { };

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/gaincoder/invidious-router";
    description = "Go application that routes requests to different Invidious instances based on their health status and (optional) response time";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ sils ];
    mainProgram = "invidious-router";
  };
}
