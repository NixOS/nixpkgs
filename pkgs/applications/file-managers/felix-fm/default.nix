{ lib, rustPlatform, fetchFromGitHub, zoxide }:

rustPlatform.buildRustPackage rec {
  pname = "felix";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yMuV7a8nkdymgJTPuVcZ/PEA2/Vr7rQf8mpikNe3e1w=";
  };

  cargoSha256 = "sha256-yePPIehyv11f58HQzFoPh7izSPjmbhdVu9xlHD6PGRY=";

  checkInputs = [ zoxide ];

  meta = with lib; {
    description = "A tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
