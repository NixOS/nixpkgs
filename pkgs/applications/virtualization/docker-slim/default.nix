{ lib, buildGoModule, fetchFromGitHub, makeBinaryWrapper }:

buildGoModule rec {
  pname = "docker-slim";
<<<<<<< HEAD
  version = "1.40.4";
=======
  version = "1.40.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "slimtoolkit";
    repo = "slim";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-A5qMg+mgcvK0YyJLbnFdZRS3s+OFWFaLKmnyvKj4r4g=";
=======
    hash = "sha256-pRIfIgEM0olUi0LL8maB7vczcq4p67eDuWssoeOT4Tk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  subPackages = [ "cmd/slim" "cmd/slim-sensor" ];

  nativeBuildInputs = [ makeBinaryWrapper ];

<<<<<<< HEAD
  preBuild = ''
    go generate github.com/docker-slim/docker-slim/pkg/appbom
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ldflags = [
    "-s"
    "-w"
    "-X github.com/docker-slim/docker-slim/pkg/version.appVersionTag=${version}"
    "-X github.com/docker-slim/docker-slim/pkg/version.appVersionRev=${src.rev}"
  ];

  # docker-slim tries to create its state dir next to the binary (inside the nix
  # store), so we set it to use the working directory at the time of invocation
  postInstall = ''
    wrapProgram "$out/bin/slim" --add-flags '--state-path "$(pwd)"'
  '';

  meta = with lib; {
    description = "Minify and secure Docker containers";
    homepage = "https://slimtoolkit.org/";
    changelog = "https://github.com/slimtoolkit/slim/raw/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne marsam mbrgm ];
  };
}
