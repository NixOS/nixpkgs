{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "todiff";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Ekleog";
    repo = "todiff";
    rev = version;
    sha256 = "1y0v8nkaqb8kn61xwarpbyrq019gxx1f5f5p1hzw73nqxadc1rcm";
  };

  cargoSha256 = "0xn5p71qk0ahd2drklja16xwv7zw0797kkzpiv563kffzvd1p8id";

  checkPhase = "cargo test --features=integration_tests";

  meta = with stdenv.lib; {
    description = "Human-readable diff for todo.txt files";
    homepage = "https://github.com/Ekleog/todiff";
    maintainers = with maintainers; [ ekleog ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
