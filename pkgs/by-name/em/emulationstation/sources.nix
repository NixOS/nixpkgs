{
  fetchFromGitHub,
}:

{
  emulationstation = let
    self = {
      pname = "emulationstation";
      version = "2.11.2";

      src = fetchFromGitHub {
        owner = "RetroPie";
        repo = "EmulationStation";
        rev = "v${self.version}";
        fetchSubmodules = true;
        hash = "sha256-J5h/578FVe4DXJx/AvpRnCIUpqBeFtmvFhUDYH5SErQ=";
      };
    };
  in
    self;
}
