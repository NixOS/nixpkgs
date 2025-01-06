{
  lib,
  buildGo122Module,
  fetchFromGitHub,
}:

buildGo122Module rec {
  pname = "ali";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "nakabonne";
    repo = "ali";
    tag = "v${version}";
    hash = "sha256-/pdHlI20IzSTX2pnsbxPiJiWmOCbp13eJWLi0Tcsueg=";
  };

  vendorHash = "sha256-YWx9K04kTMaI0FXebwRQVCt0nxIwZ6xlbtI2lk3qp0M=";

  meta = {
    description = "Generate HTTP load and plot the results in real-time";
    homepage = "https://github.com/nakabonne/ali";
    changelog = "https://github.com/nakabonne/ali/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ farcaller ];
    mainProgram = "ali";
  };
}
