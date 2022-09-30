{ lib, rustPlatform, fetchFromGitHub, zoxide }:

rustPlatform.buildRustPackage rec {
  pname = "felix";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = pname;
    rev = "v${version}";
    sha256 = "180f2crd134rp3r2333nhc78nzf1n6jryfc7n2qb6ckfkrkzb7zi";
  };

  cargoSha256 = "sha256-VDIk0xb/p1eqxFFYTFdSnkSuHLnTcVh5tGBuCUj0dnw=";

  checkInputs = [ zoxide ];

  meta = with lib; {
    description = "A tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
