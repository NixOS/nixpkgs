{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ddns-go";
  version = "6.16.0";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = "ddns-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BpNdaEk1Cw91i8JTm3Zk6rzS9kcYP006gyLHh34i0O8=";
  };

  vendorHash = "sha256-oOhqr0D/K9FITCbz2jt+We6gyv85ipL3enbr8YDDSIg=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  # network required
  doCheck = false;

  meta = {
    homepage = "https://github.com/jeessy2/ddns-go";
    description = "Simple and easy to use DDNS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "ddns-go";
  };
})
