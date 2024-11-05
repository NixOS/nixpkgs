{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "boundary";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "boundary";
    rev = "v${version}";
    hash = "sha256-BSGMF6Gea6KzzQi2xW/67ZkqMKfp44y5UZrF65eDePw=";
  };

  vendorHash = "sha256-+o33bXrgth2gFn0a9pQWjmDTfHAHk8mZVsgo+ahHkUw=";

  subPackages = [ "cmd/boundary" ];

  tags = [ "boundary" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/boundary/version.GitCommit=${src.rev}"
    "-X github.com/hashicorp/boundary/version.Version=${version}"
    "-X github.com/hashicorp/boundary/version.VersionPrerelease="
    "-X github.com/hashicorp/boundary/version.BuildDate=1970-01-01T00:00:00Z"
  ];

  meta = with lib; {
    homepage = "https://boundaryproject.io/";
    changelog = "https://github.com/hashicorp/boundary/blob/v${version}/CHANGELOG.md";
    description = "Enables identity-based access management for dynamic infrastructure";
    longDescription = ''
      Boundary provides a secure way to access hosts and critical systems
      without having to manage credentials or expose your network, and is
      entirely open source.

      Boundary is designed to be straightforward to understand, highly scalable,
      and resilient. It can run in clouds, on-prem, secure enclaves and more,
      and does not require an agent to be installed on every end host.
    '';
    license = licenses.bsl11;
    maintainers = with maintainers; [
      jk
      techknowlogick
    ];
    platforms = platforms.unix;
    mainProgram = "boundary";
  };
}
