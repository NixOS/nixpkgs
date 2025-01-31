{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubergrunt";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "kubergrunt";
    rev = "v${version}";
    sha256 = "sha256-FOXnerB6qmUUotWLlTTsR5x0+A0Q9D8PVDTMG8j8b9o=";
  };

  vendorHash = "sha256-rgU6Yv+gmKShWfpPaWtK2VIBPgFSsPVOnUzIp2+V7oI=";

  # Disable tests since it requires network access and relies on the
  # presence of certain AWS infrastructure
  doCheck = false;

  postInstall = ''
    # The binary is named kubergrunt
    mv $out/bin/cmd $out/bin/kubergrunt
  '';

  meta = with lib; {
    description = "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl";
    mainProgram = "kubergrunt";
    homepage = "https://github.com/gruntwork-io/kubergrunt";
    license = licenses.asl20;
    maintainers = with maintainers; [ psibi ];
  };
}
