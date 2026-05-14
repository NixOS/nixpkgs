{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "kaf";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "birdayz";
    repo = "kaf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gLFUv+4wGH1FOpa4DHHwSV7nSCxo+MzdNmo0I0SD/p0=";
  };

  vendorHash = "sha256-U4nmC08z7xtvRdy2xzvBqTmxJhQKI0BjJDkUwDZOQg0=";

  nativeBuildInputs = [ installShellFiles ];

  # Many tests require a running Kafka instance
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kaf \
      --bash <($out/bin/kaf completion bash) \
      --zsh <($out/bin/kaf completion zsh) \
      --fish <($out/bin/kaf completion fish)
  '';

  meta = {
    description = "Modern CLI for Apache Kafka, written in Go";
    mainProgram = "kaf";
    homepage = "https://github.com/birdayz/kaf";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zarelit ];
  };
})
