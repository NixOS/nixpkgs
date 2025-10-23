{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "drone-runner-docker";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "drone-runners";
    repo = "drone-runner-docker";
    tag = "v${version}";
    sha256 = "sha256-xJbmxoyL4Sb6YkkwgysGte44ZBKYHjc5QdYa+b62C/M=";
  };

  vendorHash = "sha256-KcNp3VdJ201oxzF0bLXY4xWHqHNz54ZrVSI96cfhU+k=";

  meta = with lib; {
    maintainers = [ ];
    license = licenses.unfreeRedistributable;
    homepage = "https://github.com/drone-runners/drone-runner-docker";
    description = "Drone pipeline runner that executes builds inside Docker containers";
    mainProgram = "drone-runner-docker";
  };
}
