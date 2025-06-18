{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "sha256-unPqjheT8/2gVQAwvzOvHtG4qTqggf9o0M5iLwl1eh4=";
  };

  vendorHash = "sha256-4BseFdfJjR8Th+NJ82dYsz9Dym1hzDa4kB4bpy71q7Q=";

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  meta = {
    description = "Kubernetes controller and tool for one-way encrypted Secrets";
    mainProgram = "kubeseal";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    changelog = "https://github.com/bitnami-labs/sealed-secrets/blob/v${version}/RELEASE-NOTES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ groodt ];
  };
}
