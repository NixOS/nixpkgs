{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "iam-policy-json-to-terraform";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "flosell";
    repo = "iam-policy-json-to-terraform";
    rev = version;
    sha256 = "sha256-xIhe+Mnvog+xRu1qMA7yxS1pCs91cr5EcaJroO+0zJ8=";
  };

  vendorHash = "sha256-6EtOMs+Vba39hOQ029dHpHCJ9ke35PZ/em9Xye3dmvg=";

  meta = {
    description = "Small tool to convert an IAM Policy in JSON format into a Terraform aws_iam_policy_document";
    homepage = "https://github.com/flosell/iam-policy-json-to-terraform";
    changelog = "https://github.com/flosell/iam-policy-json-to-terraform/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ivankovnatsky ];
  };
}
