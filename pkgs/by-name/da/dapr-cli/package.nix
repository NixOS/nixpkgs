{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGoModule rec {
  pname = "dapr-cli";
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "dapr";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-S7z6v4J+ZsSgsupU0AYcRgFmIG8szbMoW5tFIix9HBs=";
  };

  vendorHash = "sha256-RH802JcEHzrVEf4t7O0croSc36LNM6MtFXFJtDffIvU=";

  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  ldflags = [
    "-X main.version=${version}"
    "-X main.apiVersion=1.0"
    "-X github.com/dapr/cli/pkg/standalone.gitcommit=${src.rev}"
    "-X github.com/dapr/cli/pkg/standalone.gitversion=${version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/dapr

    installShellCompletion --cmd dapr \
      --bash <($out/bin/dapr completion bash) \
      --zsh <($out/bin/dapr completion zsh)
  '';

  meta = with lib; {
    description = "CLI for managing Dapr, the distributed application runtime";
    homepage = "https://dapr.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
      joshvanl
      lucperkins
    ];
    mainProgram = "dapr";
  };
}
