{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "krelay";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "knight42";
    repo = "krelay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EFdirFxBsAmXPrk9wEz6x+1T90wDrWnXuxOz2+dNpY0=";
  };

  vendorHash = "sha256-IooNsDlXcZt3NLj8CLh1XgxduqalAizSXI6/a71nNlk=";

  subPackages = [ "cmd/client" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/knight42/krelay/pkg/constants.ClientVersion=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/client $out/bin/kubectl-relay
  '';

  meta = {
    description = "Drop-in replacement for `kubectl port-forward` with some enhanced features";
    homepage = "https://github.com/knight42/krelay";
    changelog = "https://github.com/knight42/krelay/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ivankovnatsky ];
    mainProgram = "kubectl-relay";
  };
})
