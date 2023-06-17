{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.45.18";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-J4edaMLvL9Bs1bwF+m0LMGiGmEKa7Xcb3SgOiDldTyY=";
  };

  vendorHash = "sha256-5Umoqi2D6iUk2Ut7YB/nmkOyA6Rx2qFhy/ZbfqoX5qA=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=v${version}"
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
    maintainers = with maintainers; [ jk ];
  };
}
