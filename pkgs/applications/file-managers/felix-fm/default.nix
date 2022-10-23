{ lib, rustPlatform, fetchFromGitHub, zoxide }:

rustPlatform.buildRustPackage rec {
  pname = "felix";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DXsuTmkfzWbjpTb3ZJRVSDGgivDlEQraqAeyRzAB4UU=";
  };

  cargoSha256 = "sha256-gv7ujyAbFEpz95cHRDKPxUW2TiYiJz35jfiKlzi6gJY=";

  checkInputs = [ zoxide ];

  meta = with lib; {
    description = "A tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
