{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "okta-aws-cli";
  version = "2.5.2";

  subPackages = [ "cmd/okta-aws-cli" ];

  src = fetchFromGitHub {
    owner = "okta";
    repo = "okta-aws-cli";
    rev = "v${version}";
    sha256 = "sha256-z+bW/cTy63bGEhF7ug2GUXDB+kbTi4WhUEuHPOu5iw4=";
  };

  vendorHash = "sha256-MnK0zCwPOTzsPrkULEYwnmIBmVrPiwK2yDr3tqVHHRY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI for having Okta as the IdP for AWS CLI operations";
    homepage = "https://github.com/okta/okta-aws-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daniyalsuri6 ];
    mainProgram = "okta-aws-cli";
  };
}
