{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pachyderm";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "pachyderm";
    repo = "pachyderm";
    rev = "v${version}";
    hash = "sha256-Gm/aUkwEbWxj76Q6My1Vw2gRn3+WVG6EJ7PLpQ1F130=";
  };

  vendorHash = "sha256-MVcbeQ4qAX9zVlT81yZd5xvo1ggVNpCZJozBoql2W9o=";

  subPackages = [ "src/server/cmd/pachctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pachyderm/pachyderm/v${lib.versions.major version}/src/version.AppVersion=${version}"
  ];

  meta = with lib; {
    description = "Containerized Data Analytics";
    homepage = "https://www.pachyderm.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ offline ];
    mainProgram = "pachctl";
  };
}
