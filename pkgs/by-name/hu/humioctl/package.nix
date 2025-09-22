{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGoModule rec {
  pname = "humioctl";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "humio";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-2vkzde4l6GIIBzzNSewCtaVlBqkqpZQGXjw7VdJFPaE=";
  };

  vendorHash = "sha256-vGX77+I/zdTBhVSywd7msjrJ0KtcdZRgvWZWQC9M9og=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd humioctl \
      --bash <($out/bin/humioctl completion bash) \
      --zsh <($out/bin/humioctl completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/humio/cli";
    description = "CLI for managing and sending data to Humio";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "humioctl";
  };
}
