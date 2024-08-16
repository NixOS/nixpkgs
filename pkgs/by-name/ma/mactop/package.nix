{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mactop";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "context-labs";
    repo = "mactop";
    rev = "refs/tags/v${version}";
    hash = "sha256-BcBUOI5EE04ZTPoHGrNQjctsDFbMoe/6MZaLj/58c34=";
  };

  vendorHash = "sha256-/KecVx4Gp776t8gFSO29E1q9v29nwrKIWZYCpj7IlSo=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Terminal-based monitoring tool 'top' designed to display real-time metrics for Apple Silicon chips";
    homepage = "https://github.com/context-labs/mactop";
    changelog = "https://github.com/context-labs/mactop/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "mactop";
    platforms = [ "aarch64-darwin" ];
  };
}
