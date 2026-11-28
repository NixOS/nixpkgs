{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "kubecm";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oo6oKbeRBqqPoGX3HS3Z/cM6LO3GUj0BylUiV9IVdpo=";
  };

  vendorHash = "sha256-TqKVywWmMynVcqWjjE9j/mrrgCUVqRMqJZLDoNVgZF0=";
  ldflags = [
    "-s"
    "-w"
    "-X github.com/sunny0826/kubecm/version.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kubecm \
      --bash <($out/bin/kubecm completion bash) \
      --fish <($out/bin/kubecm completion fish) \
      --zsh <($out/bin/kubecm completion zsh)
  '';

  doCheck = false;

  meta = {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      qjoly
      sailord
    ];
    mainProgram = "kubecm";
  };
})
