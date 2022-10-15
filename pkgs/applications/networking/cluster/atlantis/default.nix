{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atlantis";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    sha256 = "sha256-5zchElzEjrIgODRUvQTQwlBz5371iJU5VOpz12Xtbcg=";
  };

  vendorSha256 = "sha256-n2yzqNjmPDP+8/ipiuUt6BqFYF0Oh0Y0TCdKsqCcrIQ=";

  subPackages = [ "." ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/atlantis version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpotier ];
  };
}
