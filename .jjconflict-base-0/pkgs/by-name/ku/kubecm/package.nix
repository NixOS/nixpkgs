{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "kubecm";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
    hash = "sha256-osyxgwJIHsnTW8uDKPFO174ImUntKHmW61v6KPY1E9M=";
  };

  vendorHash = "sha256-rSha+Fd8vohRnLjECqRn3Zg4DYxGgXc4M7mUAgvW+Gw=";
  ldflags = [
    "-s"
    "-w"
    "-X github.com/sunny0826/kubecm/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kubecm \
      --bash <($out/bin/kubecm completion bash) \
      --fish <($out/bin/kubecm completion fish) \
      --zsh <($out/bin/kubecm completion zsh)
  '';

  doCheck = false;

  meta = with lib; {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      qjoly
      sailord
    ];
    mainProgram = "kubecm";
  };
}
