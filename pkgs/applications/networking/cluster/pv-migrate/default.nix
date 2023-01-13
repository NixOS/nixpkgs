{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pv-migrate";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-I66J1/N8Ln7KBQfzg39wdZuM6PeJGn1HiNK2YVzDySw";
  };

  subPackages = [ "cmd/pv-migrate" ];

  vendorSha256 = "sha256-/klqOfM0ZhbzZWOLm0pA0/RB84kvfEzFJN1OQUVSNEA";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
    "-X main.commit=${src.rev}"
  ];

  preBuild = ''
    ldflags+=" -X main.date=1970-01-01-00:00:01"
  '';

  meta = with lib; {
    description = "CLI tool to easily migrate Kubernetes persistent volumes ";
    homepage = "https://github.com/utkuozdemir/pv-migrate";
    changelog = "https://github.com/utkuozdemir/pv-migrate/releases/tag/${version}";
    license = licenses.afl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
