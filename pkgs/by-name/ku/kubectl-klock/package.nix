{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule rec {
  pname = "kubectl-klock";
  version = "0.7.2";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "applejag";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S7cpVRVboLkU+GgvwozJmfFAO29tKpPlk+r9mbVLxF8=";
  };

  vendorHash = "sha256-xz1I79FklKNpWdoQdzpXYAnKM+7FJcGn04lKH2E9A50=";

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
