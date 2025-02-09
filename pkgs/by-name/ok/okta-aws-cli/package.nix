{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "okta-aws-cli";
  version = "2.4.0";

  subPackages = [ "cmd/okta-aws-cli" ];

  src = fetchFromGitHub {
    owner = "okta";
    repo = "okta-aws-cli";
    rev = "v${version}";
    sha256 = "sha256-+QNy8slVfoC85AVIcAOF4LAHX7rGac3srRyX3zDffDs=";
  };

  vendorHash = "sha256-7PuB4fsclHg9YwY8ezp/pUA7c41PIzSZtEc6qjLeIcY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "CLI for having Okta as the IdP for AWS CLI operations";
    homepage = "https://github.com/okta/okta-aws-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ daniyalsuri6 ];
    mainProgram = "okta-aws-cli";
  };
}
