{ lib, rustPlatform, fetchFromGitHub, zoxide }:

rustPlatform.buildRustPackage rec {
  pname = "felix";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7WeikYd/mADsp9DQ0jelhuZo5ZiyJrHG9HBg/YLpjZY=";
  };

  cargoSha256 = "sha256-IUiyDk+TRfODXQ+45ARcFximkLVk32pqvJfn23H0kAw=";

  checkInputs = [ zoxide ];

  meta = with lib; {
    description = "A tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
