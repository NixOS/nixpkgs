{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "docker-slim";
  version = "1.38.0";

  src = fetchFromGitHub {
    owner = "docker-slim";
    repo = "docker-slim";
    rev = version;
    sha256 = "sha256-UDEM7KCTkx+9GTkC8LSkcf4u6SozI3yYrdDwAdjeiLg=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/docker-slim" "cmd/docker-slim-sensor" ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/docker-slim/docker-slim/pkg/version.appVersionTag=${version}"
    "-X github.com/docker-slim/docker-slim/pkg/version.appVersionRev=${src.rev}"
  ];

  # docker-slim tries to create its state dir next to the binary (inside the nix
  # store), so we set it to use the working directory at the time of invocation
  postInstall = ''
    wrapProgram "$out/bin/docker-slim" --add-flags '--state-path "$(pwd)"'
  '';

  meta = with lib; {
    description = "Minify and secure Docker containers";
    homepage = "https://dockersl.im/";
    changelog = "https://github.com/docker-slim/docker-slim/raw/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne marsam mbrgm ];
  };
}
