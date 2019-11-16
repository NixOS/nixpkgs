{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rsClock";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "valebes";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i93qkz6d8sbk78i4rvx099hnn4lklp4cjvanpm9ssv8na4rqvh2";
  };
   
  cargoSha256 = "0zg5q2p9snpfyxl0gx87ix1f46afrfm5jq0m6c7s8qw2x9hpvxzr";

  meta = with stdenv.lib; {
    description = "A simple terminal clock written in Rust";
    homepage = "https://github.com/valebes/rsClock";
    license = licenses.mit;
    maintainers = with maintainers; [valebes];
    platforms = platforms.all;
  };
}

