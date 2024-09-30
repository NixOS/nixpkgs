{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:

buildGoModule rec {
  pname = "cirrus-cli";
  version = "0.130.2";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OnB7e0KYXxHGcG8ilTZ3/Na/g9Ai8/QM8x6wAOa6glE=";
  };

  vendorHash = "sha256-rYg0cmW63IolYQ79R9pFiFXD6UfESv4jq9kn1EGJmgw=";

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
