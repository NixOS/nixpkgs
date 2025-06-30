{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "cirrus-cli";
  version = "0.145.1";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = "cirrus-cli";
    rev = "v${version}";
    hash = "sha256-RyT0pR/hcqkvavI4HkWjCG5AS4H5hBbjOChHrUoq2GI=";
  };

  vendorHash = "sha256-CvypJVRLdMr38Qn8E67IZ33cSq5fYhM3i5HyifXGYNE=";

  ldflags = [
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Version=v${version}"
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Commit=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd cirrus \
      --bash <($out/bin/cirrus completion bash) \
      --zsh <($out/bin/cirrus completion zsh) \
      --fish <($out/bin/cirrus completion fish)
  '';

  # tests fail on read-only filesystem
  doCheck = false;

  meta = with lib; {
    description = "CLI for executing Cirrus tasks locally and in any CI";
    homepage = "https://github.com/cirruslabs/cirrus-cli";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ techknowlogick ];
    mainProgram = "cirrus";
  };
}
