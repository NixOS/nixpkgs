{
  lib,
  stdenv,
  fetchFromGitHub,
  imlib2,
  libX11,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "ssocr";
  version = "2.24.1";

  src = fetchFromGitHub {
    owner = "auerswal";
    repo = "ssocr";
    rev = "v${version}";
    sha256 = "sha256-5v97v9sBoHDCH2onpmBI7otK9UuhqJbM1TMapKp4XsM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    imlib2
    libX11
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Seven Segment Optical Character Recognition";
    homepage = "https://github.com/auerswal/ssocr";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.kroell ];
    mainProgram = "ssocr";
    platforms = lib.platforms.unix;
  };
}
