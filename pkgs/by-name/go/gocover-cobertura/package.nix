{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gocover-cobertura";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "boumenot";
    repo = "gocover-cobertura";
    rev = "v${version}";
    sha256 = "sha256-Cxv1iuCYHSI0BFR1OLbeDIQfVLlMDxlTgU7ljpXWHjU=";
  };

  deleteVendor = true;
  vendorHash = "sha256-b1fUikmBnc+q0KsRhK9p4VJjVnt6XFjmX9AE48TAxXg=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/boumenot/gocover-cobertura";
    description = "Simple helper tool for generating XML output in Cobertura format for CIs like Jenkins and others from go tool cover output";
    mainProgram = "gocover-cobertura";
    license = licenses.mit;
    maintainers = with maintainers; [
      gabyx
      hmajid2301
    ];
  };
}
