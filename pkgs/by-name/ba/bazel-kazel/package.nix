{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "bazel-kazel";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "repo-infra";
    rev = "v${version}";
    sha256 = "sha256-Y9VOlFrFmJQCQuwf3UztHGuJqmq/lSibTbI3oGjtNuE=";
  };

  vendorHash = "sha256-1+7Mx1Zh1WolqTpWNe560PRzRYaWVUVLvNvUOysaW5I=";

  doCheck = false;

  subPackages = [ "cmd/kazel" ];

<<<<<<< HEAD
  meta = {
    description = "BUILD file generator for go and bazel";
    homepage = "https://github.com/kubernetes/repo-infra";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kalbasit ];
=======
  meta = with lib; {
    description = "BUILD file generator for go and bazel";
    homepage = "https://github.com/kubernetes/repo-infra";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "kazel";
  };
}
