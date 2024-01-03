{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pachyderm";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "pachyderm";
    repo = "pachyderm";
    rev = "v${version}";
    hash = "sha256-h+0fapvAWu+W29Z8tZn6evhaGBM0u4odTz9ExCvsqB4=";
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
