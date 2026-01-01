{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubergrunt";
<<<<<<< HEAD
  version = "0.18.5";
=======
  version = "0.18.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "kubergrunt";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-aze/Cq5hFTRRGE1F3LLcZpWPTjpBlc2RHVkoBiP4RaU=";
  };

  vendorHash = "sha256-CNvYn/d26V0fqmPh2BbkzMgv3jWwWpGtOqowrND+igk=";
=======
    sha256 = "sha256-yrAFm4dvujwxRVjMDlTAOjBpftxdv6kuQIIcbiVnFgU=";
  };

  vendorHash = "sha256-zpYc8DurFG6Hqmf8YDSapFbHIvE1HGs5yajrLWtewO4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Disable tests since it requires network access and relies on the
  # presence of certain AWS infrastructure
  doCheck = false;

  postInstall = ''
    # The binary is named kubergrunt
    mv $out/bin/cmd $out/bin/kubergrunt
  '';

<<<<<<< HEAD
  meta = {
    description = "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl";
    mainProgram = "kubergrunt";
    homepage = "https://github.com/gruntwork-io/kubergrunt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ psibi ];
=======
  meta = with lib; {
    description = "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl";
    mainProgram = "kubergrunt";
    homepage = "https://github.com/gruntwork-io/kubergrunt";
    license = licenses.asl20;
    maintainers = with maintainers; [ psibi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
