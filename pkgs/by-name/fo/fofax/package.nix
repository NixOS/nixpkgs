{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "fofax";
  version = "0.1.47";

  src = fetchFromGitHub {
    owner = "xiecat";
    repo = "fofax";
    rev = "v${version}";
    hash = "sha256-DNidfQjehWn+/aFhfEHr2l39UVvCSv+5jNZyOLWxTbc=";
  };

  vendorHash = null;

  modRoot = "cmd/fofax";

  meta = {
    description = "Command line query tool based on fofa.info API";
    homepage = "https://github.com/xiecat/fofax";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hakutaku ];
    mainProgram = "fofax";
  };
}
