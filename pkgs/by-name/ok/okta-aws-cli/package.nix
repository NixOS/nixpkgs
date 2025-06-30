{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "okta-aws-cli";
  version = "2.5.0";

  subPackages = [ "cmd/okta-aws-cli" ];

  src = fetchFromGitHub {
    owner = "okta";
    repo = "okta-aws-cli";
    rev = "v${version}";
    sha256 = "sha256-IGecHT/JVKsaHG9OtPTOlu+ZCDbnqf1h3s4SI7+8oT8=";
  };

  vendorHash = "sha256-MnK0zCwPOTzsPrkULEYwnmIBmVrPiwK2yDr3tqVHHRY=";

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
