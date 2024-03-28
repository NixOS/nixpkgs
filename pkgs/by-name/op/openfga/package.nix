{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "openfga";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "openfga";
    rev = "v${version}";
    hash = "sha256-lqAoIOnizfvZm/NjGeinXzoci+ykmzdFtLDGeNoi97c=";
  };

  vendorHash = "sha256-vUfyo7/mapAzNs6RV+GVj5gOPEpMypNNIkoUgnBYTjA=";

  subPackages = [ "cmd/openfga" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openfga/openfga/internal/build.Version=v${version}"
    "-X github.com/openfga/openfga/internal/build.Commit=${src.rev}"
    "-X github.com/openfga/openfga/internal/build.Date=1970-01-01-00:00:01"
    "-X github.com/openfga/openfga/internal/build.ProjectName=openfga"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd openfga \
      --bash <($out/bin/openfga completion bash) \
      --zsh <($out/bin/openfga completion zsh) \
      --fish <($out/bin/openfga completion fish)
  '';

  meta = with lib; {
    homepage = "https://github.com/openfga/openfga";
    description = "A high-performance and flexible authorization/permission engine built for developers and inspired by Google Zanzibar";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
    platforms = platforms.all;
    mainProgram = "openfga";
  };
}
