{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule rec {
  pname = "kubectl-klock";
  version = "0.7.0";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "applejag";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MmsHxB15gCz2W2QLC6E7Ao+9iLyVaYJatUgPcMuL79M=";
  };

  vendorHash = "sha256-lhawUcjB2EULpAFjBM4tdmDo08za2DfyZUvEPo4+LXE=";

  postInstall = ''
    makeWrapper $out/bin/kubectl-klock $out/bin/kubectl_complete-klock --add-flags __complete
  '';

  meta = with lib; {
    description = "Kubectl plugin to render watch output in a more readable fashion";
    homepage = "https://github.com/applejag/kubectl-klock";
    changelog = "https://github.com/applejag/kubectl-klock/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.scm2342 ];
  };
}
