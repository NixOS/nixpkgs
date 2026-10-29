{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "bazel-kazel";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "repo-infra";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-m3DoReEtgkRaAfj6fcPFBaUgng4E4wFLU2Lsaug46PU=";
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
