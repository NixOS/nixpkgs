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

  cargoSha256 = "1vyc230a2b0dry2057mkdkrjb7s9d0p43fnz4q67aqrpyr4jxwx2";

  checkPhase = "cargo test --features=integration_tests";

  meta = with stdenv.lib; {
    description = "Human-readable diff for todo.txt files";
    homepage = "https://github.com/Ekleog/todiff";
    maintainers = with maintainers; [ ekleog ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
