{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubergrunt";
  version = "0.18.5";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "kubergrunt";
    rev = "v${version}";
    sha256 = "sha256-aze/Cq5hFTRRGE1F3LLcZpWPTjpBlc2RHVkoBiP4RaU=";
  };

  vendorHash = "sha256-CNvYn/d26V0fqmPh2BbkzMgv3jWwWpGtOqowrND+igk=";

  # Disable tests since it requires network access and relies on the
  # presence of certain AWS infrastructure
  doCheck = false;

  postInstall = ''
    # The binary is named kubergrunt
    mv $out/bin/cmd $out/bin/kubergrunt
  '';

  meta = {
    description = "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl";
    mainProgram = "kubergrunt";
    homepage = "https://github.com/gruntwork-io/kubergrunt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ psibi ];
  };
}
