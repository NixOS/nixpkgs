{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "kubecfg";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "kubecfg";
    repo = "kubecfg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zUPz/y47thlGDw1OFsHO6+WG6PuLzKGn17SnhO7okiw=";
  };

  vendorHash = "sha256-irXFpynf0o9+JCAU78NFtW70AYpqWsYBSvk8JhIRFC8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kubecfg \
      --bash <($out/bin/kubecfg completion --shell=bash) \
      --zsh  <($out/bin/kubecfg completion --shell=zsh)
  '';

  meta = {
    description = "Tool for managing Kubernetes resources as code";
    mainProgram = "kubecfg";
    homepage = "https://github.com/kubecfg/kubecfg";
    changelog = "https://github.com/kubecfg/kubecfg/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      qjoly
    ];
  };
})
