{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pachyderm";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "pachyderm";
    repo = "pachyderm";
    rev = "v${version}";
    hash = "sha256-ULZAmv3U6nMlhXuR6ZbZgAkWubs7t4qJBn05s0CF8uo=";
  };

  vendorHash = "sha256-dYQicGlk+G3l03yb+PlIaMzwRcWqC1TPqQ4Akm8xJF8=";

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
