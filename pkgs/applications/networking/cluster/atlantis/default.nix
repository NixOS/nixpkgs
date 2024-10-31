{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atlantis";
  version = "0.28.5";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    hash = "sha256-oyECtP/YeEhvsltWZq52YNq+Gbbpko9bbbUTh5NA/9c=";
  };
  ldflags = [
    "-X=main.version=${version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  vendorHash = "sha256-oiRpmGfuc37s3ZD8R7L9EFieqJP7mYvDsiJBzruCSkA=";

  subPackages = [ "." ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/atlantis version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    mainProgram = "atlantis";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpotier ];
  };
}
