{
  lib,
  buildGoModule,
  fetchFromGitHub,
  bash,
}:

buildGoModule rec {
  pname = "kubectl-neat";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "itaysk";
    repo = "kubectl-neat";
    rev = "v${version}";
    hash = "sha256-j8v0zJDBqHzmLamIZPW9UvMe9bv/m3JUQKY+wsgMTFk=";
  };

  vendorHash = "sha256-vGXoYR0DT9V1BD/FN/4szOal0clsLlqReTFkAd2beMw=";

  postBuild = ''
    # Replace path to bash in a script
    # Without this change, there's a problem when running tests
    sed 's,#!/bin/bash,#!${bash}/bin/bash,' -i test/kubectl-stub
  '';

  meta = with lib; {
    description = "Clean up Kubernetes yaml and json output to make it readable";
    mainProgram = "kubectl-neat";
    homepage = "https://github.com/itaysk/kubectl-neat";
    changelog = "https://github.com/itaysk/kubectl-neat/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.koralowiec ];
  };
}
