{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubergrunt";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "kubergrunt";
    rev = "v${version}";
    sha256 = "sha256-9ZF2O4/5n5uL+FA50Rfiq9gStQwNDWIhtz2GvJVu+u4=";
  };

  vendorHash = "sha256-6dFIW2wwu6HHvoMo0+MhvKOtAJNVhg7JyVlBPqLQerw=";

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
