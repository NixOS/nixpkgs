{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ultralist";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ultralist";
    repo = "ultralist";
    rev = version;
    sha256 = "sha256-GGBW6rpwv1bVbLTD//cU8jNbq/27Ls0su7DymCJTSmY=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Simple GTD-style todo list for the command line";
    homepage = "https://ultralist.io";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
    mainProgram = "ultralist";
  };
}
