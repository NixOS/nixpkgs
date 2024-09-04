{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:

buildGoModule rec {
  pname = "cirrus-cli";
  version = "0.124.2";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S57ApSuO3Mo/GpoaXx0dKOU3CfdQXmPM8AWi8fZ9MfY=";
  };

  vendorHash = "sha256-BbBwia47E6EtoEzO2c2fhjg6WHGHTnzl5VyVYxIMu6E=";

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
