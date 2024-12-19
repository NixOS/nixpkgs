{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "licensor";
  version = "unstable-2021-02-03";

  src = fetchFromGitHub {
    owner = "raftario";
    repo = pname;
    rev = "1897882a708ec6ed65a9569ae0e07d6ea576c652";
    sha256 = "0x0lkfrj7jka0p6nx6i9syz0bnzya5z9np9cw09zm1c9njv9mm32";
  };

  cargoHash = "sha256-gEOMOb2VRx0cFnzmfKBh9W1FoI4Nr7/PW4GQnldoxsA=";

  # https://github.com/raftario/licensor/issues/67
  postPatch = ''
    sed "/Copyright (c) 2021/s/2021/$(date +%Y)/" -i tests/integration.rs
  '';

  meta = with lib; {
    description = "Write licenses to stdout";
    homepage = "https://github.com/raftario/licensor";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "licensor";
  };
}
