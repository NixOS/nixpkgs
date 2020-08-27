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
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "jansc";
    repo = "ncgopher";
    rev = "v${version}";
    sha256 = "1mv89sanmr49b9za95jl5slpq960b246j2054r8xfafzqmbp44af";
  };

  cargoSha256 = "12r4vgrg2bkr3p61yxcsg02kppg84vn956l0v1vb08i94rxzc8zk";

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
