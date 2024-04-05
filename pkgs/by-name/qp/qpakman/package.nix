{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  libpng,
  zlib,
}:
stdenv.mkDerivation {
  pname = "qpakman";
  version = "2024-03-07";

  src = fetchFromGitHub {
    owner = "fhomolka";
    repo = "qpakman";
    rev = "5a76df23c11f4da619448c60a1a2ba35c316ec2b";
    sha256 = "sha256-DzP1PTzXRn8mKnPzMpxXnN9ZvFPMWWuVedll+FjFcj4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libpng
    zlib
  ];

  meta = with lib; {
    homepage = "https://github.com/fhomolka/qpakman";
    description = "A command-line tool for managing PAK and WAD files from QuakeI/II & Hexen II";
    longDescription = '''';
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
