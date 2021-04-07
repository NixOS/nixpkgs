{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "kibi";
  version = "0.2.2";

  cargoSha256 = "sha256-8iEUOLFwHBLS0HQL/oLnv6lcV3V9Hm4jMqXkqPvIF9E=";

  src = fetchFromGitHub {
    owner = "ilai-deutel";
    repo = "kibi";
    rev = "v${version}";
    sha256 = "sha256-ox1qKWxJlUIFzEqeyzG2kqZix3AHnOKFrlpf6O5QM+k=";
  };

  meta = with lib; {
    description = "A text editor in ≤1024 lines of code, written in Rust";
    homepage = "https://github.com/ilai-deutel/kibi";
    license = licenses.mit;
    maintainers = with maintainers; [ robertodr ];
  };
}
