{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubergrunt";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "kubergrunt";
    rev = "v${version}";
    sha256 = "sha256-C3anYYyhRT+/0jO01uEBX1LLQadovO+Z9JA6nHTNXOo=";
  };

  vendorHash = "sha256-AUw1wJNWjpNVsjw/Hr1ZCePYWQkf1SqRVnQgi8tOFG0=";

  # Disable tests since it requires network access and relies on the
  # presence of certain AWS infrastructure
  doCheck = false;

  postInstall = ''
    # The binary is named kubergrunt
    mv $out/bin/cmd $out/bin/kubergrunt
  '';

  meta = with lib; {
    description = "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl";
    homepage = "https://github.com/gruntwork-io/kubergrunt";
    license = licenses.asl20;
    maintainers = with maintainers; [ psibi ];
  };
}
