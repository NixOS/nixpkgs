{ lib, buildGoModule, fetchFromGitHub, makeBinaryWrapper }:

buildGoModule rec {
  pname = "docker-slim";
  version = "1.40.2";

  src = fetchFromGitHub {
    owner = "slimtoolkit";
    repo = "slim";
    rev = version;
    hash = "sha256-byB7GTw0hHY4dp3CkMCl6ga/Zn82+K6qmyWy6ezCLoE=";
  };

  vendorHash = null;

  subPackages = [ "cmd/slim" "cmd/slim-sensor" ];

  nativeBuildInputs = [ makeBinaryWrapper ];

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
