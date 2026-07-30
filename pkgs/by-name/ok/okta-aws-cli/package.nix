{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "okta-aws-cli";
  version = "2.6.0";

  subPackages = [ "cmd/okta-aws-cli" ];

  src = fetchFromGitHub {
    owner = "okta";
    repo = "okta-aws-cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-NiW0wclSL9QLPiP4zZ9/CohrRBp2rn5CblqrsKVNJK8=";
  };

  vendorHash = "sha256-MEtwJZWadQcKAdJS5LhGdIJV2OZKoRJRu87o4J6sruU=";

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
})
