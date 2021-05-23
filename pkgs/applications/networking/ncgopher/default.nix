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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jansc";
    repo = "ncgopher";
    rev = "v${version}";
    sha256 = "sha256-Yny5zZe5x7/pWda839HcFkHFuL/jl1Q7ykTZzKy871I=";
  };

  cargoSha256 = "sha256-C4V1WsAUFtr+N64zyBk1V0E8gTM/U54q03J6Nj8ReLk=";

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
