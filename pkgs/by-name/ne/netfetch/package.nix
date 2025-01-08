{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:
buildGoModule rec {
  pname = "netfetch";
  version = "5.2.10";

  src = fetchFromGitHub {
    owner = "deggja";
    repo = "netfetch";
    rev = "refs/tags/${version}";
    hash = "sha256-N3wKpWdG92cXH0TwAkcsld9TRrfPRkbw0uZY/X4d+xk=";
  };

  vendorHash = "sha256-/Em3hx5tiQjThLBPJDHGsqxUV3eXeymJ5pY9c601OW0=";

  proxyVendor = true;

  subPackages = [ "backend" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/deggja/netfetch/backend/cmd.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mv $out/bin/backend $out/bin/$pname
    installShellCompletion --cmd $pname \
      --bash <($out/bin/$pname completion bash) \
      --fish <($out/bin/$pname completion fish) \
      --zsh <($out/bin/$pname completion zsh)
  '';

  meta = {
    homepage = "https://github.com/deggja/netfetch";
    description = "Kubernetes tool for scanning clusters for network policies and identifying unprotected workloads";
    license = lib.licenses.mit;
    mainProgram = "netfetch";
    maintainers = with lib.maintainers; [ banh-canh ];
  };
}
