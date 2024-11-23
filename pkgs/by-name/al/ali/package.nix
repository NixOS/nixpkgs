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
    rev = "refs/tags/v${version}";
    hash = "sha256-/pdHlI20IzSTX2pnsbxPiJiWmOCbp13eJWLi0Tcsueg=";
  };

  vendorHash = "sha256-YWx9K04kTMaI0FXebwRQVCt0nxIwZ6xlbtI2lk3qp0M=";

  meta = with lib; {
    description = "Generate HTTP load and plot the results in real-time";
    homepage = "https://github.com/nakabonne/ali";
    changelog = "https://github.com/nakabonne/ali/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ farcaller ];
    mainProgram = "ali";
  };
}
