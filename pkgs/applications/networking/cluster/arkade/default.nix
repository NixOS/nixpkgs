{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "arkade";
  version = "0.8.29";

  src = fetchFromGitHub {
    owner = "alexellis";
    repo = "arkade";
    rev = version;
    sha256 = "sha256-VCscevLGRpBgqxhRNcvIkCdroE0MawG1fROVOLjZLW0=";
  };

  CGO_ENABLED = 0;

  vendorSha256 = "sha256-CoIlqDMmhZY+B5SEabmnbP2QUu1jkFluCzLp3Y8Z7n0=";

  # Exclude pkg/get: tests downloading of binaries which fail when sandbox=true
  subPackages = [
    "."
    "cmd"
    "pkg/apps"
    "pkg/archive"
    "pkg/config"
    "pkg/env"
    "pkg/helm"
    "pkg/k8s"
    "pkg/types"
  ];

  ldflags = [
    "-s" "-w"
    "-X github.com/alexellis/arkade/cmd.GitCommit=ref/tags/${version}"
    "-X github.com/alexellis/arkade/cmd.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/alexellis/arkade";
    description = "Open Source Kubernetes Marketplace";
    license = licenses.mit;
    maintainers = with maintainers; [ welteki techknowlogick ];
  };
}
