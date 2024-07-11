{ lib, stdenv, fetchFromGitHub, imlib2, libX11, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ssocr";
  version = "2.24.0";

  src = fetchFromGitHub {
    owner = "auerswal";
    repo = "ssocr";
    rev = "v${version}";
    sha256 = "sha256-79AnlO5r3IWSsV7zcI8li63bWTa+jw99cdOFFOGFZ2w=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ imlib2 libX11 ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Seven Segment Optical Character Recognition";
    homepage = "https://github.com/auerswal/ssocr";
    license = licenses.gpl3;
    maintainers = [ maintainers.kroell ];
    mainProgram = "ssocr";
    platforms = platforms.unix;
  };
}
