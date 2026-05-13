{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "drone-runner-docker";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "drone-runners";
    repo = "drone-runner-docker";
    tag = "v${version}";
    sha256 = "sha256-17i74U6PfOhvxdTeNrH0tQY/T46PMhRM/ggvE5BB0gY=";
  };

  vendorHash = "sha256-7iU7IE3lo8A3TO6LXF5D+/VEOTbfTJzWBFO0dycOSLs=";

  meta = {
    maintainers = [ ];
    license = lib.licenses.unfreeRedistributable;
    homepage = "https://github.com/drone-runners/drone-runner-docker";
    description = "Drone pipeline runner that executes builds inside Docker containers";
    mainProgram = "drone-runner-docker";
  };
}
