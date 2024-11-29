{ lib
, stdenv
, buildPackages
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "diffoci";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "reproducible-containers";
    repo = "diffoci";
    rev = "v${version}";
    hash = "sha256-ZVWnfg5uWYuqsNd4X6t1gWBGMfdcirSp7QZZDhqAfaI=";
  };

  vendorHash = "sha256-qb4HvK4UbJbtP/ypeptV/MMbhOu5UZDaGartq/RGpDM=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/reproducible-containers/diffoci/cmd/diffoci/version.Version=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      diffoci = if stdenv.buildPlatform.canExecute stdenv.hostPlatform then placeholder "out" else buildPackages.diffoci;
    in
    ''
      installShellCompletion --cmd trivy \
        --bash <(${diffoci}/bin/diffoci completion bash) \
        --fish <(${diffoci}/bin/diffoci completion fish) \
        --zsh <(${diffoci}/bin/diffoci completion zsh)
    '';

  meta = with lib; {
    description = "Diff for Docker and OCI container images";
    homepage = "https://github.com/reproducible-containers/diffoci/";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
    mainProgram = "diffoci";
  };
}
