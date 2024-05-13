{ buildGoModule
, fetchFromGitHub
, installShellFiles
, kubectl
, lib
}:

buildGoModule rec {
  pname = "litmusctl";
  version = "1.5.0";

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
    hash = "sha256-FORrvPKDTG48WV03+HbXiBJa1IHfHV7yMDhQX64kn6U=";
  };

  vendorHash = "sha256-U4dp2E2TZ3rds63PS6GzUVhb2qDSv92bf9JCkWpdLew=";

  postInstall = ''
    installShellCompletion --cmd litmusctl \
      --bash <($out/bin/litmusctl completion bash) \
      --fish <($out/bin/listmusctl completion fish) \
      --zsh <($out/bin/litmusctl completion zsh)
  '';

  meta = {
    description = "Command-Line tool to manage Litmuschaos's agent plane";
    homepage = "https://github.com/litmuschaos/litmusctl";
    license = lib.licenses.asl20;
    mainProgram = "litmusctl";
    maintainers = with lib.maintainers; [ vinetos sailord ];
  };
}
