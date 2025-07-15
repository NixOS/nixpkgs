{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pulumictl";
  version = "0.0.49";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumictl";
    rev = "v${version}";
    sha256 = "sha256-VEfDKkavZWWxfE1J2Cy/lnPyHiOJWOtwwcYpeb1pkkM=";
  };

  vendorHash = "sha256-IqJdbeayUcTTEiPAar1goqubAjTavJNYOzCyKXGd0Q8=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumictl/pkg/version.Version=${src.rev}"
  ];

  subPackages = [ "cmd/pulumictl" ];

  meta = with lib; {
    description = "Swiss Army Knife for Pulumi Development";
    mainProgram = "pulumictl";
    homepage = "https://github.com/pulumi/pulumictl";
    license = licenses.asl20;
    maintainers = with maintainers; [ vincentbernat ];
  };
}
