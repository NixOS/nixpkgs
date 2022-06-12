{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "genact";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ouDaOs72vivJBZVwcJhv4YoPKQOEBctUTqubvrpoBtI=";
  };

  cargoSha256 = "sha256-csubycZaBUHPp8XJ1C+nWw7DzVGVJm38/Dgw41qUMYQ=";

  meta = with lib; {
    description = "A nonsense activity generator";
    homepage = "https://github.com/svenstaro/genact";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
