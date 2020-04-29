{ stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "kibi";
  version = "0.2.0";

  cargoSha256 = "0zyqzb3k4ak7h58zjbg9b32hz1vgbbn9i9l85j4vd4aw8mhsz0n9";

  src = fetchFromGitHub {
    owner = "ilai-deutel";
    repo = "kibi";
    rev = "v${version}";
    sha256 = "1cqnzw6gpsmrqcz82zn1x5i6najcr3i7shj0wnqzpwppff9a6yac";
  };

  meta = with stdenv.lib; {
    description = "A text editor in ≤1024 lines of code, written in Rust";
    homepage = "https://github.com/ilai-deutel/kibi";
    license = licenses.mit;
    maintainers = with maintainers; [ robertodr ];
  };
}
