{ lib
, buildGoPackage
, fetchFromGitHub
, makeWrapper
}:

buildGoPackage rec {
  pname = "docker-slim";
  version = "1.37.5";

  goPackagePath = "github.com/docker-slim/docker-slim";

  src = fetchFromGitHub {
    owner = "docker-slim";
    repo = "docker-slim";
    rev = version;
    sha256 = "sha256-MBs0ybBXsanNFt6R7+ZYvtCh7iHE3FtWXE9uy9tbrE4=";
  };

  subPackages = [ "cmd/docker-slim" "cmd/docker-slim-sensor" ];

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [
    "-s" "-w"
    "-X ${goPackagePath}/pkg/version.appVersionTag=${version}"
    "-X ${goPackagePath}/pkg/version.appVersionRev=${src.rev}"
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
