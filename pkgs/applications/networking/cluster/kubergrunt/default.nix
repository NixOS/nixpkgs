{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubergrunt";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "kubergrunt";
    rev = "v${version}";
    sha256 = "sha256-K94cGU+cFHOrAGXjHQFFFJYhZi9zNfdlGy5eb2DkcV8=";
  };

  vendorSha256 = "sha256-95rteSEMOBQnAw0QKuj5Yyi8n3xXGl0Tm97WiyTGxVw=";

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
