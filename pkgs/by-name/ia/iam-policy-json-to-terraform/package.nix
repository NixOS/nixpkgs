{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "iam-policy-json-to-terraform";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "flosell";
    repo = "iam-policy-json-to-terraform";
    rev = version;
    sha256 = "sha256-YCkM6ddTue1nYqQj56iUADl9v72Um51TLhwwGK3USEw=";
  };

  vendorHash = "sha256-HOeMkyH7voQAXCRCdfpv/Cy9oLJDY+DXwh4h2yFf7Nk=";

  meta = {
    description = "Small tool to convert an IAM Policy in JSON format into a Terraform aws_iam_policy_document";
    homepage = "https://github.com/flosell/iam-policy-json-to-terraform";
    changelog = "https://github.com/flosell/iam-policy-json-to-terraform/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ivankovnatsky ];
  };
}
