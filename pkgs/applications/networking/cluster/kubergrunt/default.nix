{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubergrunt";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "kubergrunt";
    rev = "v${version}";
    sha256 = "sha256-PY3qWIK1Q5vW9CgX1F41wf1FbThY0Y/gU9R5XkRDHfA=";
  };

  vendorSha256 = "sha256-HupAsDuBLQnuMpG3gvpnhVZhQ6oSxAm9UNdJ8UHzNBU=";

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
