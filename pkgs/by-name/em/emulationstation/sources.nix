{ fetchFromGitHub }:

{
  emulationstation =
    let
      self = {
        pname = "emulationstation";
        version = "2.11.2";

        src = fetchFromGitHub {
          owner = "RetroPie";
          repo = "EmulationStation";
          rev = "v${self.version}";
          hash = "sha256-f2gRkp+3Pp2qnvg2RBzaHPpzhAnwx0+5x1Pe3kD90xE=";
        };
      };
    in
    self;

  pugixml =
    let
      self = {
        pname = "pugixml";
        version = "1.8.1";

        src = fetchFromGitHub {
          owner = "zeux";
          repo = "pugixml";
          rev = "v${self.version}";
          hash = "sha256-LbjTN1hnIbqI79C+gCdwuDG0+B/5yXf7hg0Q+cDFIf4=";
        };
      };
    in
    self;
}
