{ stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "kibi";
  version = "0.2.1";

  cargoSha256 = "1cbiidq0w5f9ynb09b6828p7p7y5xhpgz47n2jsl8mp96ydhy5lv";

  src = fetchFromGitHub {
    owner = "ilai-deutel";
    repo = "kibi";
    rev = "v${version}";
    sha256 = "1x5bvvq33380k2qhs1bwz3f9zl5q1sl7iic47pxfkzv24bpjnypb";
  };

  meta = with stdenv.lib; {
    description = "A text editor in ≤1024 lines of code, written in Rust";
    homepage = "https://github.com/ilai-deutel/kibi";
    license = licenses.mit;
    maintainers = with maintainers; [ robertodr ];
  };
}
