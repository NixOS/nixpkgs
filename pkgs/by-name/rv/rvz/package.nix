{
  lib,
  buildGoModule,
  fetchFromGitHub,
  zlib,
}:

buildGoModule rec {
  pname = "rvz";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "bodgit";
    repo = "rvz";
    rev = "v${version}";
    hash = "sha256-OxU+Pm9OfFuwmmc2+b7eLhN8JR3SB8cjvh9lPS0qJ5Y=";
  };

  vendorHash = "sha256-Spmp0ZuvC0IpbfZrXNzJQ18LIuRRfwvuwf3E7S+30GY=";

  buildInputs = [ zlib ];

  rev = "aa4ae9eeff06cd2942db0d5af5f4fa5872530256";
  buildDate = "2022-11-18T23:11:47Z";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${rev}"
    "-X main.date=${buildDate}"
  ];

  subPackages = [ "cmd/rvz" ];

  checkPhase = ''
    go test -v -short -coverprofile=cover.out ./...
  '';

  meta = {
    description = "Golang library for reading RVZ disc images";
    homepage = "https://github.com/bodgit/rvz";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dansbandit ];
    mainProgram = "rvz";
  };
}
