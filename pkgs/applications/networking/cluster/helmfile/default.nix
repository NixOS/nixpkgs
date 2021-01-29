{ lib, buildGoModule, fetchFromGitHub, makeWrapper, kubernetes-helm }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.138.1";

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-ZViDnV2b9od3yBfROBBZPsuFX8FH/rSO/epZtuCO1ps=";
  };

  vendorSha256 = "sha256-BWWmdKrxay0Qy5z+UFFZ3we5C7wI1KUHv6qHF4TPzJE=";

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
