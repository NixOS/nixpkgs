{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "genact";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lZNVXBIYl9niqdwNcSzQwQTdxlA4kKQ/WrEt93cQDJU=";
  };

  cargoSha256 = "sha256-9IiA7KAaj9bLJ7QSB/ojLEiUVv0FGYsu9by4NSfMtiE=";

  meta = with lib; {
    description = "A nonsense activity generator";
    homepage = "https://github.com/svenstaro/genact";
    changelog = "https://github.com/svenstaro/genact/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
