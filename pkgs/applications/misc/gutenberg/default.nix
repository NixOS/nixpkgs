{ stdenv, fetchFromGitHub, rustPlatform, cmake }:

with rustPlatform;

buildRustPackage rec {
  name = "gutenberg-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Keats";
    repo = "gutenberg";
    rev = "v${version}";
    sha256 = "0mc9wxwv8lk4l2yghqfvgv25bb2mly7dllfm31gm94kpmm4kkh8k";
  };

  cargoSha256 = "0mjxyfx923ynxjanc3qp24w7rg44gk2z4fnfwzkqza40r02nfwnf";

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "An opinionated static site generator with everything built-in";
    homepage = https://www.getgutenberg.io/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
