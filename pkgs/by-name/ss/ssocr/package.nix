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
  version = "2.25.0";

  src = fetchFromGitHub {
    owner = "auerswal";
    repo = "ssocr";
    rev = "v${version}";
    sha256 = "sha256-yQPjs4kGvp6C7kFcWQ3EzoFhwEAhm2nC7yXu9RbU4os=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    imlib2
    libX11
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Seven Segment Optical Character Recognition";
    homepage = "https://github.com/auerswal/ssocr";
    license = licenses.gpl3;
    mainProgram = "ssocr";
    platforms = platforms.unix;
  };
}
