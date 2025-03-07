{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "okta-aws-cli";
  version = "2.4.1";

  subPackages = [ "cmd/okta-aws-cli" ];

  src = fetchFromGitHub {
    owner = "okta";
    repo = "okta-aws-cli";
    rev = "v${version}";
    sha256 = "sha256-4S7pXPdHUgMNg+3bCsalEH9m9Hl15mX9IEl2eBqIWqA=";
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
