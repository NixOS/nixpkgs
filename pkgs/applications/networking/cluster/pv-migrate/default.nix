{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pv-migrate";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-M+M2tK40d05AxBmTjYKv5rrebX7g+Za8KX+/Q3aVLwE=";
  };

  subPackages = [ "cmd/pv-migrate" ];

  vendorHash = "sha256-3uqN6RmkctlE4GuYZQbY6wbHyPBJP15O4Bm0kTtW8qo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
    "-X main.commit=${src.rev}"
    "-X main.date=1970-01-01-00:00:01"
  ];

  meta = with lib; {
    description = "CLI tool to easily migrate Kubernetes persistent volumes ";
    homepage = "https://github.com/utkuozdemir/pv-migrate";
    changelog = "https://github.com/utkuozdemir/pv-migrate/releases/tag/${version}";
    license = licenses.afl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
