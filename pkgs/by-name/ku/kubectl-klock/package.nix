{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-klock";
  version = "0.9.3";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "applejag";
    repo = "kubectl-klock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BtQO2+0uE2A7f3hJ/GwOcO+cX6gWfHIPrfVQsVety3E=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-yITY1x2TcTtZZopWNGqFtydVS1gO9LGCRHHwgC79wDA=";

  postInstall = ''
    makeWrapper $out/bin/kubectl-klock $out/bin/kubectl_complete-klock --add-flags __complete
  '';

  meta = {
    description = "Kubectl plugin to render watch output in a more readable fashion";
    homepage = "https://github.com/applejag/kubectl-klock";
    changelog = "https://github.com/applejag/kubectl-klock/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      scm2342
      applejag
    ];
  };
})
