{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "bazel-kazel";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "repo-infra";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Y9VOlFrFmJQCQuwf3UztHGuJqmq/lSibTbI3oGjtNuE=";
  };

  vendorHash = "sha256-1+7Mx1Zh1WolqTpWNe560PRzRYaWVUVLvNvUOysaW5I=";

  doCheck = false;

  subPackages = [ "cmd/kazel" ];

  meta = {
    description = "BUILD file generator for go and bazel";
    homepage = "https://github.com/kubernetes/repo-infra";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kalbasit ];
    mainProgram = "kazel";
  };
})
