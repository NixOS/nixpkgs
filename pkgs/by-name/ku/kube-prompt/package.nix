{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kube-prompt";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "c-bata";
    repo = "kube-prompt";
    rev = "v${version}";
    sha256 = "sha256-9OWsITbC7YO51QzsRwDWvojU54DiuGJhkSGwmesEj9w=";
  };

  vendorHash = "sha256-wou5inOX8vadEBCIBccwSRjtzf0GH1abwNdUu4JBvyM=";

<<<<<<< HEAD
  meta = {
    description = "Interactive kubernetes client featuring auto-complete";
    mainProgram = "kube-prompt";
    license = lib.licenses.mit;
    homepage = "https://github.com/c-bata/kube-prompt";
    maintainers = with lib.maintainers; [ vdemeester ];
=======
  meta = with lib; {
    description = "Interactive kubernetes client featuring auto-complete";
    mainProgram = "kube-prompt";
    license = licenses.mit;
    homepage = "https://github.com/c-bata/kube-prompt";
    maintainers = with maintainers; [ vdemeester ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
