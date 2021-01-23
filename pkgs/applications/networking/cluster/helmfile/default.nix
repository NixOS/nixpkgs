{ lib, buildGoModule, fetchFromGitHub, makeWrapper, kubernetes-helm }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.137.0";

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-HrVQS09lllUC4HClWahMV72j2TiQnzEUkV16YKm6984=";
  };

  vendorSha256 = "sha256-dL36mcYCs92USf18BMB6vXd+qLsk2BYmAEm1bwx+o5k=";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/roboll/helmfile/pkg/app/version.Version=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/helmfile \
      --prefix PATH : ${lib.makeBinPath [ kubernetes-helm ]}
  '';

  meta = {
    description = "Deploy Kubernetes Helm charts";
    homepage = "https://github.com/roboll/helmfile";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pneumaticat yurrriq ];
    platforms = lib.platforms.unix;
  };
}
