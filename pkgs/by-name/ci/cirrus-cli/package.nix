{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "cirrus-cli";
  version = "0.154.0";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = "cirrus-cli";
    rev = "v${version}";
    hash = "sha256-jmjCqdoJj9ggxC6JaW7BObWCWKdfB0ZOSOfUA2BgUCc=";
  };

  vendorHash = "sha256-ag1HzNrSqGTJGXxhdspxHsJRBu7tuB5nDFiEWh1VOsU=";

  ldflags = [
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Version=v${version}"
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Commit=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
