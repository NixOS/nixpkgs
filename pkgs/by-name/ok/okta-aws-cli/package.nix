{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "okta-aws-cli";
  version = "2.3.1";

  subPackages = [ "cmd/okta-aws-cli" ];

  src = fetchFromGitHub {
    owner = "okta";
    repo = "okta-aws-cli";
    rev = "v${version}";
    sha256 = "sha256-dts2aTd90bsuTkXB6AxFN6IziOQXTG1XLT0XSAC1Avc=";
  };

  vendorHash = "sha256-2VTq8lzGYBKH410/mflloAphWTwFie3mdmz2kLkfuQ0=";

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
