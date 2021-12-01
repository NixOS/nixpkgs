{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, ncurses6
, openssl
, sqlite
}:

rustPlatform.buildRustPackage rec {
  pname = "ncgopher";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "jansc";
    repo = "ncgopher";
    rev = "v${version}";
    sha256 = "sha256-1tiijW3q/8zS9437G9gJDzBtxqVE3QUxgw74P7rcv98=";
  };

  cargoSha256 = "sha256-LA8LjY8oZslGFQhKR8fJ2heYxSBqUnmeejXKRvZXjIs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    ncurses6
    openssl
    sqlite
  ];

  meta = with lib; {
    description = "A gopher and gemini client for the modern internet";
    homepage = "https://github.com/jansc/ncgopher";
    license = licenses.bsd2;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
