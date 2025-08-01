{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "aaa";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "DomesticMoth";
    repo = "aaa";
    tag = "v${version}";
    sha256 = "sha256-gIOlPjZOcmVLi9oOn4gBv6F+3Eq6t5b/3fKzoFqxclw=";
  };

  cargoHash = "sha256-CHX+Ugy4ND36cpxNEFpnqid6ALHMPXmfXi+D4aktPRk=";

  meta = {
    description = "Terminal viewer for 3a format";
    homepage = "https://github.com/DomesticMoth/aaa";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ asciimoth ];
    mainProgram = "aaa";
  };
}
