{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atlantis";
  version = "0.19.8";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    sha256 = "sha256-o8lBpiR8gIo1kyOTkPOIuMnJbJsi619Zl0bAAFGYM4E=";
  };

  vendorSha256 = "sha256-aEMRCvZBaY1uwZqKtMmZ4aiPdNmtANcnuE7eykBiTQg=";

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
