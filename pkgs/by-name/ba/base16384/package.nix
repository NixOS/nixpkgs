{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "base16384";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "fumiama";
    repo = "base16384";
    rev = "v${version}";
    hash = "sha256-qaDnv+KpXMYdx6eqH7pU0pEjSpU5xg9I7afxpoO3iGs=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Encode binary files to printable utf16be";
    mainProgram = "base16384";
    homepage = "https://github.com/fumiama/base16384";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.all;
  };
}
