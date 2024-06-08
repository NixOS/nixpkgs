{ lib, stdenv, fetchFromGitHub, imlib2, libX11, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ssocr";
  version = "2.23.1";

  src = fetchFromGitHub {
    owner = "auerswal";
    repo = "ssocr";
    rev = "v${version}";
    sha256 = "sha256-EfZsTrZI6vKM7tB6mKNGEkdfkNFbN5p4TmymOJGZRBk=";
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
  };
}
