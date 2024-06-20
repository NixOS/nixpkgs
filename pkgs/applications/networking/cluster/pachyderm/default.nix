{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pachyderm";
  version = "2.10.2";

  src = fetchFromGitHub {
    owner = "pachyderm";
    repo = "pachyderm";
    rev = "v${version}";
    hash = "sha256-5Q3T4yusnJVHU8QdXxbDuePToGp+hu+GnwqD7TG/0Rw=";
  };

  vendorHash = "sha256-NShVyjNyG06cLmt8rd71lFLvkd8KRWQjj6xUCx7NgSk=";

  subPackages = [ "src/server/cmd/pachctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pachyderm/pachyderm/v${lib.versions.major version}/src/version.AppVersion=${version}"
  ];

  meta = with lib; {
    description = "Containerized Data Analytics";
    homepage = "https://www.pachyderm.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    mainProgram = "pachctl";
  };
}
