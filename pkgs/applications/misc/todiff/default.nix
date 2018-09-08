{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "todiff-${version}";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Ekleog";
    repo = "todiff";
    rev = version;
    sha256 = "1y0v8nkaqb8kn61xwarpbyrq019gxx1f5f5p1hzw73nqxadc1rcm";
  };

  cargoSha256 = "1r7l9zbw6kq8yb5cv6h0qgl2gp71bkn9xv7b2n49a5r7by98jjqr";

  checkPhase = "cargo test --features=integration_tests";

  meta = with stdenv.lib; {
    description = "Human-readable diff for todo.txt files";
    homepage = https://github.com/Ekleog/todiff;
    maintainers = with maintainers; [ ekleog ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
