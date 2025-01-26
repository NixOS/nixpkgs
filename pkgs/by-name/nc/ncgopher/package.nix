{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  ncurses6,
  openssl,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "ncgopher";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "jansc";
    repo = "ncgopher";
    rev = "v${version}";
    sha256 = "sha256-KrvTwcIeINIBkia6PTnKXp4jFd6GEMBh/xbn0Ot/wmE=";
  };

  cargoHash = "sha256-Zft/ip+/uJbUIqCDDEa4hchmZZiYWGdaVnzWC74FgU8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    ncurses6
    openssl
    sqlite
  ];

  meta = with lib; {
    description = "Gopher and gemini client for the modern internet";
    homepage = "https://github.com/jansc/ncgopher";
    license = licenses.bsd2;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
    mainProgram = "ncgopher";
  };
}
