{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "versus";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "INFURA";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jX2HRdrLwDjnrUofRzmsSFLMbiPh0a1DPv1tzl+StUg=";
  };

  vendorHash = "sha256-e116ZXofSnD7+5f8xdBjpMYdeUhGPVTLfaxnhhqTIrQ=";

  meta = with lib; {
    description = "Benchmark multiple API endpoints against each other";
    homepage = "https://github.com/INFURA/versus";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
    mainProgram = "versus";
  };
}
