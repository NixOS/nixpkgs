{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "opensearch-cli";
  version = "1.2.0";
  src = fetchFromGitHub {
    repo = "opensearch-cli";
    owner = "opensearch-project";
    rev = version;
    hash = "sha256-Ah64a9hpc2tnIXiwxg/slE6fUTAoHv9koNmlUHrVj/s=";
  };

  vendorHash = "sha256-r3Bnud8pd0Z9XmGkj9yxRW4U/Ry4U8gvVF4pAdN14lQ=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    export HOME="$(mktemp -d)"
    installShellCompletion --cmd opensearch-cli \
      --bash <($out/bin/opensearch-cli completion bash) \
      --zsh <($out/bin/opensearch-cli completion zsh) \
      --fish <($out/bin/opensearch-cli completion fish)
  '';

  meta = {
    description = "Full-featured command line interface (CLI) for OpenSearch";
    homepage = "https://github.com/opensearch-project/opensearch-cli";
    license = lib.licenses.asl20;
    mainProgram = "opensearch-cli";
    maintainers = with lib.maintainers; [ shyim ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
