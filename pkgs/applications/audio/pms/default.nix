{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule {
  pname = "pms";
  version = "unstable-2022-11-12";

  src = fetchFromGitHub {
    owner = "ambientsound";
    repo = "pms";
    rev = "40d6e37111293187ab4542c7a64bd73d1b13974f";
    sha256 = "sha256-294MiS4c2PO2lFSSRrg8ns7sXzZsEUAqPG3q2z3TRUg=";
  };

  vendorHash = "sha256-XNFzG4hGDUN0wWbpBoQWUH1bWIgoYcyP4tNRGSV4ro4=";

  meta = with lib; {
    description = "An interactive Vim-like console client for MPD";
    homepage = "https://ambientsound.github.io/pms/";
    license = licenses.mit;
    maintainers = with maintainers; [ deejayem ];
    mainProgram = "pms";
  };
}
