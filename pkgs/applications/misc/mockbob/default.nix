{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mockbob";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "j-brn";
    repo = "mockbob";
    rev = version;
    sha256 = "07ygpdak4h630wvk4xjsqwphvcbrif39zkmxdagj5ic7rkahii26";
  };

  cargoSha256 = "0n94qpasvplcj1vjgqgvxg5jpczij71hfxk4mvxy9q3wa522q7mq";

  meta = with stdenv.lib; {
    homepage = "https://github.com/j-brn/mockbob/tree/master";
    description = "Convert Text to Mocking SpongeBob case <https://knowyourmeme.com/memes/mocking-spongebob>";
    license = licenses.mit;
    maintainers = [ maintainers.fionera ];
    platforms = platforms.all;
  };
}
