{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gocover-cobertura";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "boumenot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nbwqfObU1tod5gWa9UbhmS6CpLLilvFyvNJ6XjeR8Qc=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/boumenot/gocover-cobertura";
    description = "This is a simple helper tool for generating XML output in Cobertura format for CIs like Jenkins and others from go tool cover output";
    mainProgram = "gocover-cobertura";
    license = licenses.mit;
    maintainers = with maintainers; [ hmajid2301 ];
  };
}
