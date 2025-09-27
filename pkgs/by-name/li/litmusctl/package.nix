{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  kubectl,
  lib,
  stdenv,
}:

buildGoModule rec {
  pname = "litmusctl";
  version = "1.18.0";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    kubectl
  ];

  src = fetchFromGitHub {
    owner = "litmuschaos";
    repo = "litmusctl";
    rev = "${version}";
    hash = "sha256-lfR4Nk9n6mpfQVrVoI2iaCYkJelgGi5QLdZN9n0qPVQ=";
  };

  vendorHash = "sha256-7FYOQ89aUFPX+5NCPYKg+YGCXstQ6j9DK4V2mCgklu0=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd litmusctl \
      --bash <($out/bin/litmusctl completion bash) \
      --fish <($out/bin/litmusctl completion fish) \
      --zsh <($out/bin/litmusctl completion zsh)
  '';

  meta = {
    description = "Command-Line tool to manage Litmuschaos's agent plane";
    homepage = "https://github.com/litmuschaos/litmusctl";
    license = lib.licenses.asl20;
    mainProgram = "litmusctl";
    maintainers = with lib.maintainers; [
      vinetos
      sailord
    ];
  };
}
