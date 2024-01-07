{ lib, buildGoModule, fetchFromGitHub, makeBinaryWrapper }:

buildGoModule rec {
  pname = "docker-slim";
  version = "1.40.7";

  src = fetchFromGitHub {
    owner = "slimtoolkit";
    repo = "slim";
    rev = version;
    hash = "sha256-X+7FMdIotnafUEKQUrvxYgN4qGqbtVJaZD+V4/whylM=";
  };

  vendorHash = null;

  subPackages = [ "cmd/slim" "cmd/slim-sensor" ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  preBuild = ''
    go generate ./...
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/slimtoolkit/slim/pkg/version.appVersionTag=${version}"
    "-X github.com/slimtoolkit/slim/pkg/version.appVersionRev=${src.rev}"
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
