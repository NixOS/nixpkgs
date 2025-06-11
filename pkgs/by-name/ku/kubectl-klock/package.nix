{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule rec {
  pname = "kubectl-klock";
  version = "0.8.0";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "applejag";
    repo = "kubectl-klock";
    rev = "v${version}";
    hash = "sha256-1t/DJ6cTikAl2edJFfDzXAB8OgdZSjk1C7vOGXyTu0U=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-FWfAn3ZWScIXbdv3zwwZxFyMkpzJHZJuhxe22qvv1ac=";

  postInstall = ''
    makeWrapper $out/bin/kubectl-klock $out/bin/kubectl_complete-klock --add-flags __complete
  '';

  meta = {
    description = "Kubectl plugin to render watch output in a more readable fashion";
    homepage = "https://github.com/applejag/kubectl-klock";
    changelog = "https://github.com/applejag/kubectl-klock/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      scm2342
      applejag
    ];
  };
}
