{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.50.12";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-NAilGvA0S4GEQgqKKQMddemZmyFBnKE4+R689kAyoMg=";
  };

  vendorHash = "sha256-wQ5jxOTuYkiW5zHcduByKZ+vHPKn/1ELL3DskKze+UI=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gruntwork-io/go-commons/version.Version=v${version}"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terragrunt --help
    $out/bin/terragrunt --version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://terragrunt.gruntwork.io";
    changelog = "https://github.com/gruntwork-io/terragrunt/releases/tag/v${version}";
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    license = licenses.mit;
    maintainers = with maintainers; [ jk qjoly ];
  };
}
