{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rsClock";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "valebes";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i93qkz6d8sbk78i4rvx099hnn4lklp4cjvanpm9ssv8na4rqvh2";
  };

  cargoSha256 = "1vgizkdzi9mnan4rcswyv450y6a4b9l74d0siv1ix0nnlznnqyg1";

  meta = with lib; {
    description = "A simple terminal clock written in Rust";
    homepage = "https://github.com/valebes/rsClock";
    license = licenses.mit;
    maintainers = with maintainers; [valebes];
  };
}
