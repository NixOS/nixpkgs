{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "cirrus-cli";
  version = "0.137.3";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = "cirrus-cli";
    rev = "v${version}";
    hash = "sha256-7yI0dcE6hxfAZeZ5ylw5s6CBye1hTSW/nLtFZs4k/xw=";
  };

  vendorHash = "sha256-GjCwH0Xe9wyacfokI5EzF2TKUnSMKCdOljahChPBlso=";

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
