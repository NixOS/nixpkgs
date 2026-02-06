{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "okta-aws-cli";
  version = "2.5.3";

  subPackages = [ "cmd/okta-aws-cli" ];

  src = fetchFromGitHub {
    owner = "okta";
    repo = "okta-aws-cli";
    rev = "v${version}";
    sha256 = "sha256-l9sbkMcL35GezqJc1z4+1cTvJkyyCrI0NaNdVvmTSB0=";
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
