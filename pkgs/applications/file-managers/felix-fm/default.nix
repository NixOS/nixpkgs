{ lib, rustPlatform, fetchFromGitHub, zoxide }:

rustPlatform.buildRustPackage rec {
  pname = "felix";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ennEFhnAxsEtZ1LEyr9xeeR4v5IG1Vm2gs4A09IyciE=";
  };

  cargoSha256 = "sha256-unSeb8LHgJ0TspbBLhGGU6Pqy1kLMEzgIIblLUyRQWw=";

  checkInputs = [ zoxide ];

  meta = with lib; {
    description = "A tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
