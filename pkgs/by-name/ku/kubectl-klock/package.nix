{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-klock";
  version = "0.9.1";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "applejag";
    repo = "kubectl-klock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ro2OyyTL/D92C0m5c1YoZblFksvGPyspm2cYu+1vFrE=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-YjCuamn4EKJcrxfSj7Iaw1Ftyk0AzDGhZpP/wRBF92c=";

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
