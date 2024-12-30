{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "fscan";
  version = "2.0.0-build1";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    rev = version;
    hash = "sha256-ZJVdjdON7qgjxWU8/eOsmct0g/xr77fEH3PfV4JUOdw=";
  };

  vendorHash = "sha256-WDq08flKiMCN4SS9xHH3B0nCX6us6huX8SF9BPuNzoo=";

  meta = with lib; {
    description = "Intranet comprehensive scanning tool";
    homepage = "https://github.com/shadow1ng/fscan";
    license = licenses.mit;
    maintainers = with maintainers; [ Misaka13514 ];
    mainProgram = "fscan";
  };
}
