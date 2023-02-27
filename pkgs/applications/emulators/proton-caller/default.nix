{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "proton-caller";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "caverym";
    repo = pname;
    rev = version;
    sha256 = "sha256-fN/8woLkTFD0aGILwweHhpey3cGQw2NolvpOmdkEEGA=";
  };

  cargoSha256 = "sha256-2zczu9MtsDDbfjbmLXCiPJrxNoNNBN0KAGeN+a53SRg=";

  meta = with lib; {
    description = "Run Windows programs with Proton";
    changelog = "https://github.com/caverym/proton-caller/releases/tag/${version}";
    homepage = "https://github.com/caverym/proton-caller";
    license = licenses.mit;
    maintainers = with maintainers; [ kho-dialga ];
    mainProgram = "proton-call";
  };
}
